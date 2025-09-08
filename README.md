# Flight School Student Record Management System (HVE-Test)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Issues](https://img.shields.io/github/issues/jspoelstra/hve-test)](https://github.com/jspoelstra/hve-test/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/jspoelstra/hve-test)](https://github.com/jspoelstra/hve-test/pulls)

A secure, role-aware, cloud-native web application enabling flight school stakeholders (Students, CFIs, Stage-Check Instructors, Dispatch/Ops, and Administrators) to manage training progress, flight/ground lesson records, endorsements, stage checks, and regulatory compliance (FAA Part 61/141) while improving transparency, data integrity, and operational efficiency.

## 🎯 Overview

This project aims to centralize authoritative student training records and endorsements, providing real-time progress visibility to all relevant parties while reducing administrative overhead and ensuring FAA-aligned compliance.

### Key Features

- **Identity & Authorization**: Azure Entra ID integration with role-based access control
- **Syllabus Management**: Versioned training templates with lesson tracking
- **Lesson Recording**: Draft/final lesson entries with objective assessments
- **Stage Checks**: Structured evaluations with pass/fail workflows
- **Endorsements**: Template-based regulatory endorsements with integrity checking
- **Audit & Compliance**: Comprehensive logging for regulatory requirements
- **Reporting**: Student record exports and progress analytics

### Primary Goals

- Centralize authoritative student training records & endorsements
- Provide real-time progress visibility (syllabus, stage, lesson completion)
- Reduce administrative overhead, duplicate data entry, and paper reliance
- Enforce data consistency, auditability, and FAA-aligned retention
- Support scalable, secure, multi-device access with strong identity controls

## 📋 Project Status

This repository currently contains **project planning and requirements documentation**. The actual application development is tracked through epics and user stories documented in the backlog.

## 🚀 Getting Started

### Prerequisites

To contribute to this project planning phase, you'll need:

- Git for version control
- A text editor or IDE for markdown editing
- [GitHub CLI](https://cli.github.com/) (optional, for issue management)

### Clone the Repository

```bash
git clone https://github.com/jspoelstra/hve-test.git
cd hve-test
```

### Explore the Documentation

1. **Requirements**: Start with [`docs/requirements.md`](docs/requirements.md) for the complete system specification
2. **Epics**: Review planned features in [`backlog/epics/`](backlog/epics/)
3. **Issues**: Browse open issues and user stories in the GitHub Issues tab

### Understanding the Structure

```
├── docs/                    # Project documentation
│   └── requirements.md      # Comprehensive system requirements
├── backlog/                 # Project planning artifacts
│   ├── epics/              # Feature epics and user stories
│   └── README.md           # Backlog overview
├── scripts/                # Automation scripts
│   └── create_github_issues.sh  # Issue creation automation
└── README.md               # This file
```

## 🤝 Contributing

We welcome contributions to help refine the project requirements and planning!

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/your-feature-name`)
3. **Make your changes** to documentation or planning artifacts
4. **Commit your changes** (`git commit -m 'Add some feature'`)
5. **Push to the branch** (`git push origin feature/your-feature-name`)
6. **Open a Pull Request**

### Types of Contributions

- **Requirements Refinement**: Help improve or clarify system requirements
- **Epic/Story Enhancement**: Add detail to user stories or acceptance criteria
- **Documentation**: Improve README, add diagrams, or enhance explanations
- **Issue Management**: Create, label, or organize GitHub issues
- **Architecture Input**: Provide feedback on proposed technical architecture

### Issue Labels

- `epic`: High-level feature groups
- `story`: Individual user stories
- `documentation`: Documentation improvements
- `requirements`: Requirements clarification or changes
- `question`: Discussion or clarification needed

### Development Workflow

When the development phase begins, this section will be updated with:
- Local development setup
- Build and test procedures
- Code contribution guidelines
- Review processes

## 🏗️ Architecture Overview

The planned system will use:

- **Frontend**: Azure Static Web Apps (React SPA)
- **Backend**: Azure App Service (.NET or Node.js)
- **Database**: Azure SQL Database with Elastic Pool
- **Identity**: Azure Entra ID/B2C
- **Storage**: Azure Blob Storage
- **Observability**: Azure Application Insights

See [`docs/requirements.md`](docs/requirements.md) for detailed architecture specifications.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Project Owner**: Jacob Spoelstra
- **Repository**: [jspoelstra/hve-test](https://github.com/jspoelstra/hve-test)
- **Issues**: [GitHub Issues](https://github.com/jspoelstra/hve-test/issues)

## 🔗 Additional Resources

- [FAA Part 61 - Certification: Pilots](https://www.ecfr.gov/current/title-14/chapter-I/subchapter-D/part-61)
- [FAA Part 141 - Pilot Schools](https://www.ecfr.gov/current/title-14/chapter-I/subchapter-H/part-141)
- [Azure Architecture Documentation](https://docs.microsoft.com/en-us/azure/architecture/)

---

**Note**: This is currently a planning and requirements repository. Development has not yet begun.
