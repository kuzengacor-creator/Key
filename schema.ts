import { z } from "zod";

export const keySchema = z.object({
  key: z.string().length(16, "Key must be exactly 16 characters"),
  expiresAt: z.number().int().positive("Expiry time must be a positive timestamp"),
  createdAt: z.number().int().positive("Creation time must be a positive timestamp"),
});

export const insertKeySchema = keySchema.omit({ createdAt: true });

export type Key = z.infer<typeof keySchema>;
export type InsertKey = z.infer<typeof insertKeySchema>;

export const verifyKeySchema = z.object({
  key: z.string().min(1, "Key is required"),
});

export type VerifyKey = z.infer<typeof verifyKeySchema>;

export const keyVerificationResponseSchema = z.object({
  status: z.enum(["valid", "expired", "invalid"]),
  message: z.string().optional(),
});

export type KeyVerificationResponse = z.infer<typeof keyVerificationResponseSchema>;
