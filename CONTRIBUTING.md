# Contributing to WeatherGov Ruby Client

Thank you for considering contributing to the WeatherGov Ruby Client! We welcome contributions from everyone and are committed to fostering a welcoming, efficient, and productive contributor community. This document outlines the process for contributing to the project, ensuring a smooth experience for both contributors and maintainers.

---

## **Getting Started / Development Setup**

### **Required Tools**

To contribute to this project, you will need the following tools installed on your system:

- **Ruby**: Version 3.2 or higher.
- **Bundler**: For managing dependencies (`gem install bundler`).
- **Git**: For version control.
- **RSpec**: For running tests.
- **Rubocop**: For linting and formatting.

### **Installation Steps**

1. **Fork the Repository**:
   - Click the "Fork" button on the GitHub repository to create your own copy.

2. **Clone Your Fork**:

   ```bash
   git clone https://github.com/<your-username>/weather_gov_api.git
   cd weather_gov_api
   ```

3. **Install Dependencies**:

   ```bash
   bundle install
   ```

4. **Run Tests**:
   Ensure everything is working by running the test suite:

   ```bash
   bundle exec rspec
   ```

5. **Run Linters**:
   Check for style violations:

   ```bash
   bundle exec rubocop
   ```

### **Recommended IDE Setup**

We recommend using **Visual Studio Code** with the following extensions:

- **Ruby**: Provides syntax highlighting and debugging support.
- **Rubocop**: Integrates Rubocop linting into VS Code.
- **RSpec**: Adds support for running and debugging RSpec tests.

Ensure your IDE is configured to use the project-specific `.rubocop.yml` file for linting.

---

## **Reporting Bugs**

If you find a bug, please help us by submitting a detailed bug report. Use the following template when creating a new issue:

### **Bug Report Template**

```markdown
**Describe the bug**
A clear and concise description of what the bug is.

**Steps to Reproduce**
1. Go to '...'
2. Run '...'
3. Observe '...'

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots or Logs**
If applicable, add screenshots or logs to help explain your problem.

**Environment**
- Ruby version: [e.g., 3.2.0]
- OS: [e.g., macOS 13.0, Ubuntu 22.04]

**Additional context**
Add any other context about the problem here.
```

---

## **Suggesting Enhancements**

We welcome suggestions for new features or improvements! To propose an enhancement, please open a GitHub issue using the following template:

### **Enhancement Proposal Template**

```markdown
**Describe the enhancement**
A clear and concise description of the feature or improvement.

**Why is this needed?**
Explain why this feature would be useful or how it improves the project.

**Proposed solution**
Describe how you would implement the feature.

**Additional context**
Add any other context or screenshots about the feature request here.
```

---

## **Pull Request Process**

### **Guidelines for Submitting Pull Requests**

1. **Create Small, Focused PRs**:
   - Each PR should address a single issue or enhancement. This makes reviews faster and easier.
   - **DO NOT** create large, unfocused PRs that address multiple issues at once.

2. **Link to Relevant Issues**:
   - Reference the issue your PR addresses (e.g., `Closes #123`).

3. **Follow the Style Guide**:
   - Adhere strictly to the [STYLE_GUIDE.md](STYLE_GUIDE.md). Linters and formatters will enforce these rules.

4. **Write Tests**:
   - Ensure all existing tests pass.
   - Add new tests for any new functionality to prevent regressions.

5. **Write Clear Commit Messages**:
   - Use concise, informative commit messages.
   - Follow [Conventional Commits](https://www.conventionalcommits.org/) if applicable.

6. **Write a Detailed PR Description**:
   - Explain **what** the change is and **why** it is needed.
   - Include any relevant context or screenshots.

7. **Be Responsive to Feedback**:
   - Code reviews are a normal part of the process. Be prepared to make changes based on feedback.

### **Steps to Submit a Pull Request**

1. **Create a New Branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**:
   - Follow the [STYLE_GUIDE.md](STYLE_GUIDE.md).
   - Write tests for your changes.

3. **Run Tests and Linters**:

   ```bash
   bundle exec rspec
   bundle exec rubocop
   ```

4. **Commit Your Changes**:

   ```bash
   git add .
   git commit -m "feat: Add feature description"
   ```

5. **Push Your Branch**:

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request**:
   - Go to your fork on GitHub and click "Compare & pull request."
   - Fill out the PR template with a detailed description of your changes.

---

## **Code of Conduct**

This project adheres to the [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the maintainers.

---

## **Communication**

For questions, discussions, or general communication, please use the following channels:

- **GitHub Issues**: For bug reports, feature requests, and general questions.
- **Email**: Contact the maintainers at `maintainers@weather_gov_api.com`.

---

## **Further Reading**

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Writing Good Commit Messages](https://cbea.ms/git-commit/)
- [GitHub Docs: About Pull Requests](https://docs.github.com/en/pull-requests)

---

By following these guidelines, you help ensure that contributions are reviewed and merged efficiently, maintaining the project's high standards for quality and stability. Thank you for contributing!
