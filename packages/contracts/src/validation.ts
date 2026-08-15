import { z } from 'zod';

export const UserSessionSchema = z.object({
  id: z.string().uuid(),
  isGuest: z.boolean(),
  locale: z.string()
});
