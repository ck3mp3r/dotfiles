# Goose Subagent Recipes

This directory contains specialized subagent recipes for delegating specific tasks to focused AI assistants.

## Available Subagents

### 1. Research Assistant (`research-assistant`)
⭐ **Has full c5t write permissions for note-taking**

**Purpose:** Gather, analyze, and document research findings in c5t notes.

**Capabilities:**
- Comprehensive research using webfetch, context7, and other tools
- Information synthesis and analysis
- Automatic documentation in c5t notes
- Project organization and note linking

**Usage Examples:**

```bash
# Basic research
"Use the research-assistant recipe to research Rust async patterns"

# Deep research with project linking
"Use research-assistant to do a deep dive on Kubernetes networking, 
link to project abc123de"

# Quick reference research
"Use research-assistant for a quick overview of Nix flakes"
```

**Parameters:**
- `topic` (required): Research topic or question
- `depth` (optional): 'quick', 'standard', or 'deep' (default: 'standard')
- `project_id` (optional): c5t project ID to link notes to

**c5t Permissions:**
- ✅ Create, edit, delete notes
- ✅ Read projects, repos, and notes
- ✅ Create and update projects (for organizing research)

---

### 2. Code Reviewer (`code-reviewer`)

**Purpose:** Analyze code for quality, security, and best practices.

**Capabilities:**
- Code quality analysis (readability, structure, DRY)
- Security vulnerability detection (SQL injection, XSS, etc.)
- Performance review (algorithms, N+1 queries, memory)
- Best practices validation (SOLID, error handling, testing)
- Optional c5t documentation of findings

**Usage Examples:**

```bash
# General code review
"Use the code-reviewer recipe to review my authentication module"

# Security-focused review
"Use code-reviewer with focus_area='security' to audit the API endpoints"

# Document findings
"Use code-reviewer to review src/handlers/ and document_findings=true"
```

**Parameters:**
- `focus_area` (optional): 'security', 'performance', 'quality', 'all' (default: 'all')
- `severity_threshold` (optional): 'critical', 'high', 'medium', 'low' (default: 'low')
- `file_path` (optional): Specific file/directory to review
- `document_findings` (optional): Create c5t note with findings (default: false)

**Output Format:**
- Findings prioritized by severity (Critical → Low)
- Specific code examples
- Concrete fix suggestions
- Reasoning for recommendations

---

### 3. Documentation Writer (`documentation-writer`)

**Purpose:** Create comprehensive technical documentation.

**Capabilities:**
- README files (overview, installation, usage)
- API documentation (endpoints, examples, errors)
- Guides and tutorials (step-by-step, troubleshooting)
- Architecture documentation (system overview, components)
- Automatic c5t note storage

**Usage Examples:**

```bash
# Create README
"Use documentation-writer to create a README for this project"

# API documentation
"Use documentation-writer with doc_type='api' for the REST endpoints"

# Beginner-friendly guide
"Use documentation-writer to create a guide for setting up the dev environment,
audience='beginner'"
```

**Parameters:**
- `doc_type` (optional): 'readme', 'api', 'guide', 'architecture' (default: 'readme')
- `target` (optional): File, component, or system to document
- `audience` (optional): 'beginner', 'intermediate', 'expert' (default: 'intermediate')
- `save_to_c5t` (optional): Save to c5t notes (default: true)

**Documentation Standards:**
- Clear, concise language
- Practical examples
- Markdown best practices
- Table of contents for long docs
- Syntax highlighting for code

---

### 4. Testing Assistant (`testing-assistant`)

**Purpose:** Create and improve tests following TDD principles.

**Capabilities:**
- Full TDD cycle support (RED → GREEN → REFACTOR)
- Unit tests (fast, isolated, mocked dependencies)
- Integration tests (realistic data, API/DB verification)
- End-to-end tests (complete workflows)
- Test strategy documentation in c5t

**Usage Examples:**

```bash
# RED: Write failing test
"Use testing-assistant to write unit tests for the UserService class, tdd_phase='red'"

# GREEN: Make tests pass
"Use testing-assistant with tdd_phase='green' to implement UserService"

# REFACTOR: Clean up
"Use testing-assistant with tdd_phase='refactor' to improve the UserService code"

# Comprehensive test suite
"Use testing-assistant to create integration tests for the API, coverage_goal='90'"
```

**Parameters:**
- `test_type` (optional): 'unit', 'integration', 'e2e', 'all' (default: 'unit')
- `target` (optional): Function, class, or component to test
- `tdd_phase` (optional): 'red', 'green', 'refactor' (default: 'red')
- `coverage_goal` (optional): Target coverage % (default: '80')
- `document_strategy` (optional): Create c5t testing strategy note (default: false)

**TDD Workflow:**
1. **RED**: Write failing test (verify it fails)
2. **GREEN**: Minimal code to pass (don't over-engineer)
3. **REFACTOR**: Clean up (keep tests green)

**Testing Best Practices:**
- Descriptive names: `test_<what>_<condition>_<expected>`
- Arrange-Act-Assert pattern
- Test edge cases and errors
- Independent, isolated tests
- Mock external dependencies (unit tests)

---

### 5. Refactoring Assistant (`refactoring-assistant`)

**Purpose:** Safe, systematic code refactoring with git safety and SOLID principles.

**Capabilities:**
- Incremental code improvements
- SOLID principle application
- Git-based safety checkpoints
- Test-driven refactoring
- Before/after verification
- Refactoring decision documentation

**CRITICAL SAFETY RULES:**
- ✅ ALWAYS stage with `git add` before major changes
- ✅ ALWAYS run tests before and after
- ❌ NEVER auto-commit (always ask permission)
- ✅ Create safety checkpoints at logical points

**Usage Examples:**

```bash
# General refactoring with safety
"Use refactoring-assistant to refactor the UserService class"

# Extract method refactoring
"Use refactoring-assistant with goal='extract_method' to break down 
the processPayment function"

# SOLID principles focus
"Use refactoring-assistant with goal='solid' to improve the architecture
of the auth module"

# With custom test command
"Use refactoring-assistant to simplify src/handlers/, test_command='cargo test'"
```

**Parameters:**
- `target` (optional): File, class, or function to refactor
- `goal` (optional): 'extract_method', 'extract_class', 'simplify', 'solid', 'general' (default: 'general')
- `run_tests` (optional): Run tests before/after (default: true)
- `test_command` (optional): Custom test command
- `document_decisions` (optional): Create c5t refactoring note (default: false)

**Refactoring Workflow:**
1. **Analyze** - Understand code and identify issues
2. **Test** - Ensure tests pass
3. **Stage** - `git add` for safety
4. **Refactor** - Make incremental changes
5. **Test** - Verify tests still pass
6. **Review** - Check diff
7. **Document** - Record decisions (if requested)

**SOLID Principles Applied:**
- **S**ingle Responsibility Principle
- **O**pen/Closed Principle
- **L**iskov Substitution Principle
- **I**nterface Segregation Principle
- **D**ependency Inversion Principle

---

## Configuration

These recipes are installed in `~/.config/goose/recipes/` and are available via:

```nix
# In your Nix config
GOOSE_RECIPE_PATH = "$HOME/.config/goose/recipes";
```

## Default Settings

All subagents share these defaults (can be overridden):

| Setting | Default | Override |
|---------|---------|----------|
| Max Turns | 25-30 (varies) | Natural language in prompt |
| Timeout | 5 minutes | Request in prompt |
| Extensions | Inherited from parent | Specify in prompt |
| Return Mode | Full details | Request "summary only" |

## Tips

**Parallel Execution:**
```bash
"Use research-assistant and documentation-writer in parallel to research
Rust async patterns and document findings"
```

**Extension Control:**
```bash
"Use code-reviewer but don't give it write access to files"
```

**Custom Settings:**
```bash
"Use testing-assistant with 40 turns and 15-minute timeout for complex test suite"
```

**Session Isolation:**
```bash
"Use research-assistant to explore this controversial topic - 
keep it in a separate subagent so my main chat stays clean"
```

## c5t Integration

The **research-assistant** has full c5t permissions to:
- Create and organize notes
- Link notes to projects
- Tag and categorize research
- Build knowledge over time

Other subagents can optionally create c5t notes when `document_findings=true` or `save_to_c5t=true`.

## Advanced Usage

**Chaining Subagents:**
```bash
"First use research-assistant to research GraphQL best practices,
then use documentation-writer to create an implementation guide,
finally use testing-assistant to create a test suite"
```

**Specialized Workflows:**
```bash
"Use code-reviewer to audit the codebase, then use testing-assistant 
to create tests for any critical issues found"
```
