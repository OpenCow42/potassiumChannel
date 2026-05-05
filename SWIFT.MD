# Swift API Design Guidelines (Agent Summary)

This document summarizes the Swift API Design Guidelines for quick, practical use while designing APIs.

## Core Principles

- Optimize for **clarity at the call site**. Declarations are written once; usage is read many times.
- Prefer **clarity over brevity**. Shorter code is a side effect, not a goal.
- Write **documentation comments for every declaration**. If the API is hard to describe simply, redesign it.

## Documentation Style

- Use Swift Markdown in doc comments.
- Start with a concise summary sentence fragment ending with a period.
- Describe:
  - functions/methods by what they do and return,
  - subscripts by what they access,
  - initializers by what they create,
  - other declarations by what they are.
- Add extra paragraphs/bullets only when needed.
- Use standard symbol commands (for example `- Parameter:`, `- Returns:`, `- Throws:`, `- Note:`).

## Naming: Clarity First

- Include all words needed to avoid ambiguity.
- Omit needless words, especially words that only repeat type information.
- Name by **role**, not by type (for variables, parameters, associated types).
- If types are weak (`Any`, `AnyObject`, `NSObject`, primitives), add role words to restore clarity.

## Naming: Fluent Usage

- Prefer names that read like grammatical English at the use site.
- Factory methods should begin with `make` (for example, `makeIterator()`).
- Do not force initializer/factory first arguments into awkward grammar.
- Side-effect naming:
  - nonmutating: noun-like (`distance(to:)`, `isEmpty`),
  - mutating: imperative verb (`sort()`, `append(_)`).
- Mutating/nonmutating pairs should be systematic:
  - verb-based: `sort` / `sorted`, `reverse` / `reversed`, `stripNewlines` / `strippingNewlines`,
  - noun-based: `union` / `formUnion`.
- Boolean names should read as assertions (`isEmpty`, `intersects(_)`).
- Protocol names:
  - noun when describing what something is (`Collection`),
  - `able`/`ible`/`ing` when describing capability (`Equatable`, `ProgressReporting`).

## Terminology

- Avoid obscure terms unless they add real precision.
- Use technical terms only with their established meanings.
- Avoid abbreviations unless standard and searchable.
- Follow ecosystem/domain precedent (`Array`, `sin`).

## Conventions

- Document complexity for computed properties that are not `O(1)`.
- Prefer methods/properties over free functions, except when:
  - no obvious receiver exists,
  - the function is an unconstrained generic,
  - domain notation strongly favors function style.
- Use `UpperCamelCase` for types/protocols; `lowerCamelCase` for everything else.
- Acronyms/initialisms should follow normal case conventions consistently (`UTF8`, `ASCII`, `radar`).
- Share base names only for the same core semantics or clearly separate domains.
- Avoid overloading solely by return type.

## Parameters

- Choose parameter names to make docs read naturally.
- Use default parameters for common values instead of proliferating overload families.
- Place parameters with defaults toward the end where possible.
- For production-facing APIs, prefer `#fileID`; use `#filePath` for internal tooling/tests where full paths help; use `#file` only for Swift 5.2 compatibility.

## Argument Labels

- Omit labels only when arguments are genuinely indistinguishable (`min`, `zip`).
- In value-preserving type conversions, omit the first label (`Int64(x)`).
- In narrowing conversions, include a descriptive label (`truncating:`, `saturating:`).
- If first argument starts a prepositional phrase, usually keep the label at the preposition (`removeBoxes(havingLength:)`).
- If first argument completes a grammatical phrase with base name, omit its label (`addSubview(_)`).
- Label all other arguments.

## Special Cases

- Label tuple return members and name closure parameters in APIs for clarity and better docs.
- Be careful with unconstrained polymorphism and overloads (`Any`, unconstrained generics); avoid ambiguous overload sets.
- Prefer explicit labels like `contentsOf` when they disambiguate semantics.

## Practical Checklist

- Is the call site immediately clear?
- Is every name necessary, precise, and role-based?
- Do mutating/nonmutating names follow Swift patterns?
- Are argument labels helping grammar and disambiguation?
- Are docs concise, accurate, and complete enough?
- Are defaults used instead of overload bloat?
- Are weakly typed parameters and generic overloads unambiguous?
