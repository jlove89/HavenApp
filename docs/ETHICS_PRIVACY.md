# Ethics, Privacy & Legal Guidelines for HavenApp

## Purpose
Provide a safety-first framework for design, data, and operations.

## Core Principles
- **Safety-first**: prioritize survivor safety over data collection
- **Do no harm**: avoid actions that increase risk (visible notifications, forced reporting)
- **Privacy by design**: minimal data collection, local-first processing, encryption
- **Informed consent**: clear, revocable consent before data collection
- **Transparency**: explain what is collected, why, and retention periods

## Data Minimization & Storage
- Collect only for enabled features
- Prefer on-device processing; encrypt server storage (AES-256-GCM)
- Short retention: 30 days default (user can opt into longer for export/legal)
- PII stored only with explicit consent

## Consent & Control
- Clear consent screens before collection (plain language)
- Granular toggles: passive detection, location, journaling, sharing (OFF by default)
- Easy revocation: pause, export, delete anytime
- User-visible audit log of all data access

## Security
- End-to-end encryption for communications
- OS keystores (Secure Enclave / Android Keystore)
- Strict access controls; MFA for admin accounts
- Independent security audit before production

## Design & UX for Safety
- Stealth mode: customizable app icon/name
- Discreet UI: no revealing notifications
- Configurable panic button (long-press, shake, gesture)
- Quick-escape flows

## Modeling & Detection
- Prefer interpretable signals over black-box models
- On-device inference when possible
- No facial/biometric ID without explicit legal consent

## Data Sources & Labeling
- No scraping; explicit consent required
- Synthetic augmentation and expert labeling (trained advocates)
- Adversarial review for bias

## Law Enforcement
- Default: data shared externally only with user consent
- Valid warrant/subpoena required; legal review; user notification (unless prohibited)

## Ethical Review
- Advisory board: survivors, advocates, clinicians, legal counsel
- Participatory design with trauma-informed researchers

## Testing & Monitoring
- Threat modeling and abuse case testing
- Monitor false positive/negative rates
- Incident response with escalation paths

## Compliance
- GDPR, CCPA, state DV laws per jurisdiction
