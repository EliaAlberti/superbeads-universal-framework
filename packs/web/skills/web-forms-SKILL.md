# Web Forms Skill

## Description

You MUST use this skill before creating any forms in React. This applies to login forms, registration forms, settings forms, and any user input handling.

---

## Purpose

Create complete, production-ready forms that:
- Use React Hook Form for state management
- Include Zod validation
- Are accessible
- Handle errors properly
- Support loading states

## When to Use

- Creating any form
- Building multi-step wizards
- Implementing search/filter forms
- Adding settings pages

## Prerequisites

- React Hook Form installed
- Zod installed
- Form requirements clear

## Process

### Step 1: Define Schema

```tsx
// schemas/user.ts
import { z } from "zod";

export const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
});

export type LoginFormData = z.infer<typeof loginSchema>;

export const registerSchema = z
  .object({
    name: z.string().min(2, "Name must be at least 2 characters"),
    email: z.string().email("Invalid email address"),
    password: z
      .string()
      .min(8, "Password must be at least 8 characters")
      .regex(/[A-Z]/, "Must contain uppercase letter")
      .regex(/[0-9]/, "Must contain number"),
    confirmPassword: z.string(),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Passwords don't match",
    path: ["confirmPassword"],
  });

export type RegisterFormData = z.infer<typeof registerSchema>;
```

### Step 2: Create Form Component

```tsx
// components/forms/login-form.tsx
"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { loginSchema, type LoginFormData } from "@/schemas/user";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

interface LoginFormProps {
  onSubmit: (data: LoginFormData) => Promise<void>;
}

export function LoginForm({ onSubmit }: LoginFormProps) {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: "",
      password: "",
    },
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div className="space-y-2">
        <Label htmlFor="email">Email</Label>
        <Input
          id="email"
          type="email"
          placeholder="you@example.com"
          aria-describedby={errors.email ? "email-error" : undefined}
          aria-invalid={!!errors.email}
          {...register("email")}
        />
        {errors.email && (
          <p id="email-error" className="text-sm text-destructive">
            {errors.email.message}
          </p>
        )}
      </div>

      <div className="space-y-2">
        <Label htmlFor="password">Password</Label>
        <Input
          id="password"
          type="password"
          aria-describedby={errors.password ? "password-error" : undefined}
          aria-invalid={!!errors.password}
          {...register("password")}
        />
        {errors.password && (
          <p id="password-error" className="text-sm text-destructive">
            {errors.password.message}
          </p>
        )}
      </div>

      <Button type="submit" className="w-full" disabled={isSubmitting}>
        {isSubmitting ? "Signing in..." : "Sign in"}
      </Button>
    </form>
  );
}
```

### Step 3: Create Reusable Form Components

```tsx
// components/ui/form.tsx
"use client";

import * as React from "react";
import { useFormContext, Controller } from "react-hook-form";
import { cn } from "@/lib/utils";
import { Label } from "./label";

interface FormFieldProps {
  name: string;
  label: string;
  children: React.ReactNode;
  description?: string;
}

export function FormField({ name, label, children, description }: FormFieldProps) {
  const {
    formState: { errors },
  } = useFormContext();

  const error = errors[name];
  const errorId = `${name}-error`;
  const descId = `${name}-description`;

  return (
    <div className="space-y-2">
      <Label htmlFor={name}>{label}</Label>
      {description && (
        <p id={descId} className="text-sm text-muted-foreground">
          {description}
        </p>
      )}
      {React.Children.map(children, (child) => {
        if (React.isValidElement(child)) {
          return React.cloneElement(child, {
            id: name,
            "aria-describedby": cn(
              error && errorId,
              description && descId
            ),
            "aria-invalid": !!error,
          } as any);
        }
        return child;
      })}
      {error && (
        <p id={errorId} className="text-sm text-destructive" role="alert">
          {error.message as string}
        </p>
      )}
    </div>
  );
}

// Controlled field for complex inputs
interface ControlledFieldProps<T> {
  name: string;
  render: (field: { value: T; onChange: (value: T) => void }) => React.ReactNode;
}

export function ControlledField<T>({ name, render }: ControlledFieldProps<T>) {
  const { control } = useFormContext();

  return (
    <Controller
      name={name}
      control={control}
      render={({ field }) => <>{render(field)}</>}
    />
  );
}
```

### Step 4: Complex Form with Multiple Sections

```tsx
// components/forms/settings-form.tsx
"use client";

import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

const settingsSchema = z.object({
  profile: z.object({
    name: z.string().min(1, "Name is required"),
    bio: z.string().max(500, "Bio must be less than 500 characters").optional(),
    avatar: z.string().url().optional(),
  }),
  notifications: z.object({
    email: z.boolean(),
    push: z.boolean(),
    marketing: z.boolean(),
  }),
  preferences: z.object({
    theme: z.enum(["light", "dark", "system"]),
    language: z.string(),
  }),
});

type SettingsFormData = z.infer<typeof settingsSchema>;

export function SettingsForm({ defaultValues }: { defaultValues: SettingsFormData }) {
  const methods = useForm<SettingsFormData>({
    resolver: zodResolver(settingsSchema),
    defaultValues,
  });

  const { handleSubmit, formState: { isSubmitting, isDirty } } = methods;

  const onSubmit = async (data: SettingsFormData) => {
    await saveSettings(data);
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
        {/* Profile Section */}
        <section>
          <h2 className="text-lg font-semibold">Profile</h2>
          <div className="mt-4 space-y-4">
            <FormField name="profile.name" label="Name">
              <Input {...methods.register("profile.name")} />
            </FormField>
            <FormField name="profile.bio" label="Bio" description="Brief description">
              <Textarea {...methods.register("profile.bio")} />
            </FormField>
          </div>
        </section>

        {/* Notifications Section */}
        <section>
          <h2 className="text-lg font-semibold">Notifications</h2>
          <div className="mt-4 space-y-4">
            <ControlledField
              name="notifications.email"
              render={({ value, onChange }) => (
                <Switch checked={value} onCheckedChange={onChange} />
              )}
            />
          </div>
        </section>

        <Button type="submit" disabled={isSubmitting || !isDirty}>
          {isSubmitting ? "Saving..." : "Save changes"}
        </Button>
      </form>
    </FormProvider>
  );
}
```

### Step 5: Multi-Step Form

```tsx
// components/forms/multi-step-form.tsx
"use client";

import { useState } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

const step1Schema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

const step2Schema = z.object({
  company: z.string().min(1),
  role: z.string().min(1),
});

const step3Schema = z.object({
  plan: z.enum(["free", "pro", "enterprise"]),
});

const fullSchema = step1Schema.merge(step2Schema).merge(step3Schema);

type FormData = z.infer<typeof fullSchema>;

const steps = [
  { schema: step1Schema, title: "Personal Info" },
  { schema: step2Schema, title: "Company Info" },
  { schema: step3Schema, title: "Choose Plan" },
];

export function MultiStepForm() {
  const [currentStep, setCurrentStep] = useState(0);

  const methods = useForm<FormData>({
    resolver: zodResolver(steps[currentStep].schema),
    mode: "onChange",
  });

  const { handleSubmit, trigger } = methods;

  const nextStep = async () => {
    const isValid = await trigger();
    if (isValid && currentStep < steps.length - 1) {
      setCurrentStep((prev) => prev + 1);
    }
  };

  const prevStep = () => {
    if (currentStep > 0) {
      setCurrentStep((prev) => prev - 1);
    }
  };

  const onSubmit = async (data: FormData) => {
    // Final submission
    console.log(data);
  };

  return (
    <FormProvider {...methods}>
      <form onSubmit={handleSubmit(onSubmit)}>
        {/* Progress indicator */}
        <div className="mb-8 flex justify-between">
          {steps.map((step, index) => (
            <div
              key={index}
              className={cn(
                "flex items-center",
                index <= currentStep ? "text-primary" : "text-muted-foreground"
              )}
            >
              <span className="flex h-8 w-8 items-center justify-center rounded-full border">
                {index + 1}
              </span>
              <span className="ml-2">{step.title}</span>
            </div>
          ))}
        </div>

        {/* Step content */}
        {currentStep === 0 && <Step1 />}
        {currentStep === 1 && <Step2 />}
        {currentStep === 2 && <Step3 />}

        {/* Navigation */}
        <div className="mt-8 flex justify-between">
          <Button
            type="button"
            variant="outline"
            onClick={prevStep}
            disabled={currentStep === 0}
          >
            Previous
          </Button>

          {currentStep < steps.length - 1 ? (
            <Button type="button" onClick={nextStep}>
              Next
            </Button>
          ) : (
            <Button type="submit">Submit</Button>
          )}
        </div>
      </form>
    </FormProvider>
  );
}
```

### Step 6: Server Action Form

```tsx
// app/actions.ts
"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";

const contactSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  message: z.string().min(10),
});

export async function submitContact(formData: FormData) {
  const result = contactSchema.safeParse({
    name: formData.get("name"),
    email: formData.get("email"),
    message: formData.get("message"),
  });

  if (!result.success) {
    return { error: result.error.flatten().fieldErrors };
  }

  await db.contact.create({ data: result.data });
  revalidatePath("/contact");

  return { success: true };
}

// components/contact-form.tsx
"use client";

import { useFormState, useFormStatus } from "react-dom";
import { submitContact } from "@/app/actions";

function SubmitButton() {
  const { pending } = useFormStatus();
  return (
    <Button type="submit" disabled={pending}>
      {pending ? "Sending..." : "Send"}
    </Button>
  );
}

export function ContactForm() {
  const [state, formAction] = useFormState(submitContact, null);

  return (
    <form action={formAction}>
      <Input name="name" />
      {state?.error?.name && <p className="text-destructive">{state.error.name}</p>}

      <Input name="email" type="email" />
      {state?.error?.email && <p className="text-destructive">{state.error.email}</p>}

      <Textarea name="message" />
      {state?.error?.message && <p className="text-destructive">{state.error.message}</p>}

      <SubmitButton />
    </form>
  );
}
```

## Output Checklist

- [ ] Zod schema defined
- [ ] Form component created
- [ ] Validation working
- [ ] Error messages displayed
- [ ] Loading states handled
- [ ] Accessibility complete
- [ ] Tests added

---

**This skill creates production-ready forms with proper validation, accessibility, and error handling.**
