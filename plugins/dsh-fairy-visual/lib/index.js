import z from '@deepseek-ai/schemastery';
import {
  FAIRY_IDENTITY_SETTINGS_NAMESPACE,
  FAIRY_VISUAL_SETTINGS_NAMESPACE,
  FAIRY_VISUAL_SETTINGS_VERSION,
} from './contracts/index.js';
import { createFairyDiagnostics } from './contracts/diagnostics.js';

const diagnostics = createFairyDiagnostics('dsh-fairy-visual');

export const FairyVisualSettings = z.object({
  version: z.number().step(1).default(FAIRY_VISUAL_SETTINGS_VERSION).volatile(),
  enabled: z.boolean().default(true).volatile(),
  theme: z.union(['dark', 'light']).default('light').volatile(),
  mascotVisible: z.boolean().default(true).volatile(),
  mascotScale: z.number().step(0.01).min(0.55).max(1).default(0.55).volatile(),
  mascotAnimationSpeed: z.union([z.const(0.7), z.const(1), z.const(1.5)]).default(1).volatile(),
  powerMode: z.union(['normal', 'low-power']).default('normal').volatile(),
  composerDockHeight: z.number().step(1).min(132).max(420).default(132).volatile(),
});

export const FairyIdentitySettings = z.object({
  mode: z.union(['ling', 'zhe', 'custom']).default('ling').volatile(),
  customName: z.string().default('').volatile(),
  secondAssistant: z.string().default('').volatile(),
  household: z.array(z.string()).default([]).volatile(),
});

export const name = 'dsh-fairy-visual';

export const Config = FairyVisualSettings;

export function apply(ctx) {
  return diagnostics.guard('apply', () => {
    ctx.inject(['settings'], child => {
      child.effect(() => child.settings.configure({ auto: false }, ctx.fiber));
    });
  }, { surface: 'host' });
}
