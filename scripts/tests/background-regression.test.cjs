// Source-contract and lightweight DOM tests. Full browser/installer evidence is in docs/背景修复验证报告.json.
// These checks require no DSH_HOME, network, Electron, voice model or third-party dependencies.
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const root = path.resolve(__dirname, '../..');
const plugin = path.join(root, 'plugins/dsh-fairy-visual');
const source = fs.readFileSync(path.join(plugin, 'lib/client.js'), 'utf8');
const iife = fs.readFileSync(path.join(plugin, 'lib/index.iife.js'), 'utf8');

function selector(name) {
  const match = source.match(new RegExp(name + ': ("(?:[^"\\\\]|\\\\.)*"),'));
  assert(match, `missing adapter selector: ${name}`);
  return JSON.parse(match[1]);
}

test('client and IIFE ship the same fix', () => {
  assert.equal(source, iife);
});

test('desktop and web conversation slots are both supported', () => {
  assert.deepEqual(selector('conversation').split(','), [
    '[data-slot="main.conversation"]', '[data-slot="conversation"]',
  ]);
});

test('transparent main phase is scoped to Fairy HDD mode', () => {
  const rule = source.match(/(html\[data-dsh-fairy-visual\] \[data-dsh-fairy-background-surface="true"\],[^{]+)\{([^}]+)\}/);
  assert(rule, 'transparent surface rule not found');
  assert(rule[1].split(',').every(s => s.startsWith('html[data-dsh-fairy-visual] ')));
  assert(rule[1].includes('[data-slot="main.conversation"]>[data-phase]'));
  assert(rule[1].includes('[data-slot="conversation"]>[data-phase]'));
  for (const declaration of ['background:transparent!important', 'background-color:transparent!important', 'background-image:none!important']) {
    assert(rule[2].includes(declaration), declaration);
  }
});

test('current active or hero phase receives the semantic background marker', () => {
  assert.match(source, /const currentPhase = phase\(stage\);\s*(?:\/\/[^\n]*\n\s*)?mark\(currentPhase, "data-dsh-fairy-background-surface"\);/);
  assert.match(source, /return officialNode\("phaseActive", scope\) \|\| officialNode\("phaseHero", scope\);/);
});

test('composer outranks sticky code banners but stays behind modal backdrop', () => {
  const dock = source.match(/html\[data-dsh-fairy-visual\] \[data-dsh-fairy-composer-dock="true"\]\{([^}]+)\}/);
  assert(dock, 'regular dock rule missing');
  assert(dock[1].includes('z-index:7!important'));
  const modal = source.match(/html\[data-dsh-fairy-visual\]\[data-dsh-fairy-modal-open\][^{]+\[data-dsh-fairy-composer-dock="true"\]\{z-index:1!important\}/);
  assert(modal, 'modal dock override missing');
  assert(modal.index > dock.index, 'modal override must follow the regular dock rule');
});

test('settings adapter recognizes official portal and legacy sidebar dialog', () => {
  assert.deepEqual(selector('settingsDialog').split(','), [
    '[data-slot="sidebar.settings"] [role="dialog"]',
    '[data-shortcut-modal="settings"][role="dialog"]',
  ]);
});

test('only Visual is bumped; Voice and Orb versions remain unchanged', () => {
  const versions = Object.fromEntries(['visual', 'voice', 'orb'].map(name => [name,
    JSON.parse(fs.readFileSync(path.join(root, `plugins/dsh-fairy-${name}/package.json`), 'utf8')).version,
  ]));
  assert.deepEqual(versions, {visual: '1.1.2', voice: '1.1.1', orb: '1.1.0'});
});


// Execute the shipped marker reconciler against a small DOM fixture, not a duplicate implementation.
function markerFixture() {
  class Node {
    constructor(children = []) { this.children = children; this.isConnected = true; this.attrs = new Map(); this.mutations = []; children.forEach(n => n.parentElement = this); }
    contains(n) { return n === this || this.children.some(c => c.contains(n)); }
    getAttribute(k) { return this.attrs.get(k) ?? null; }
    setAttribute(k, v) { this.attrs.set(k, v); this.mutations.push(['set', k]); }
    removeAttribute(k) { this.attrs.delete(k); this.mutations.push(['remove', k]); }
    closest() { return seat; }
  }
  const voice = new Node(), scroll = new Node(), send = new Node();
  const tools = new Node([voice]), trailing = new Node([send]), row = new Node([tools, trailing]);
  const card = new Node([scroll, row]), bar = new Node([card]), seat = new Node([bar]);
  tools.voice = voice;
  const begin = source.indexOf('function markControls(card, previousControls) {');
  const end = source.indexOf('\n\t\tmodule.exports = {', begin);
  assert(begin !== -1 && end > begin, 'shipped marker reconciler not found');
  const deps = {
    OFFICIAL_ATTRIBUTES: {composerSeat: 'data-composer-seat'}, BRANCH_SELECTOR: '[data-gitgraph-chip-anchor]',
    inputScroll: () => scroll, sendButton: () => send, voiceControl: scope => scope?.voice,
    contextControl: () => null, commandControl: () => null, accessControl: () => null,
    modelControl: () => null, reasoningControl: () => null, modelAndReasoningShareNode: () => false,
    workspaceControl: () => null, attachmentSlot: () => null, attachmentRail: () => null,
    getComputedStyle: () => ({display: 'block'}),
    clearMarker: (node, name) => { if (node?.isConnected) node.removeAttribute(name); },
  };
  const mark = new Function(...Object.keys(deps), source.slice(begin, end).trim() + '\nreturn markControls;')(...Object.values(deps));
  return {Node, mark, card, tools, voice, nodes: [voice, scroll, send, tools, trailing, row, card, bar, seat]};
}

test('rebinding unchanged controls does not remove or rewrite live layout markers', () => {
  const f = markerFixture();
  const first = f.mark(f.card);
  f.nodes.forEach(n => n.mutations = []);
  const second = f.mark(f.card, first);
  assert.equal(f.voice.getAttribute('data-dsh-fairy-composer-voice-control'), 'true');
  assert.deepEqual(f.nodes.flatMap(n => n.mutations), []);
  second();
  assert.equal(f.voice.getAttribute('data-dsh-fairy-composer-voice-control'), null);
});

test('reconciliation removes obsolete markers and cleanup preserves unrelated attributes', () => {
  const f = markerFixture(), first = f.mark(f.card), nextVoice = new f.Node();
  f.voice.setAttribute('data-third-party', 'keep');
  f.tools.children.push(nextVoice); nextVoice.parentElement = f.tools; f.tools.voice = nextVoice;
  const second = f.mark(f.card, first);
  assert.equal(f.voice.getAttribute('data-dsh-fairy-composer-voice-control'), null);
  assert.equal(f.voice.getAttribute('data-third-party'), 'keep');
  assert.equal(nextVoice.getAttribute('data-dsh-fairy-composer-voice-control'), 'true');
  f.mark(null, second)();
  assert.equal(nextVoice.getAttribute('data-dsh-fairy-composer-voice-control'), null);
  assert.equal(f.tools.getAttribute('data-dsh-fairy-composer-tools'), null);
  assert.equal(f.voice.getAttribute('data-third-party'), 'keep');
});
