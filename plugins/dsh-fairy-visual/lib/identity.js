import { FairyIdentitySettings } from './index.js';
export const name = 'dsh-fairy-identity';
export const Config = FairyIdentitySettings;
export function apply(ctx) {
  ctx.inject(['settings'], child => {
    child.effect(() => child.settings.configure({ auto: false }, ctx.fiber));
  });
}
