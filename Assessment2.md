# Assessment

Validate Software

ICPTPRG520 Validate an application design against specifications

## PART 1

1. Develop a proof of concept
2. Present the prototype system
3. Perform design and code validation
4. Document and report validation results

A. Determine the procedures and tools required to perform

* Software requirements validation
* Database validation
* Software design validation
* Source code validation
* User Interface (UI) validation
* Test validation

B. Now it is time to design and build a prototype.
1. Identify a prototyping tool to develop proof of concept
2. Identify the use cases from the software requirements.
3. Develop a prototype using the selected tool.

C. Save your word-processed document as VDP_Part1

## PART 2

10-15 minutes to present your prototype

Role Play Participants:
  Client and Developer.

1. Identify each use case requirements that you need to fulfil
2. Confirm the completeness and correctness of the requirements using appropriate questioning and listening techniques.
3. Demonstrate the prototype (from Part 1) to the client and determine whether any further refinements need to be made.
4. Record the outcome of the presentation and any changes required in a document.

## PART 3

Now you have implement selected use cases, its time for you to validate it.

Record your validation details
- Date
- Name
- Procedures
- Results (including screen shots)

1. Validate the software design to ensure the design is complete, accurate and feasible.
   1. Include diagrams, class, erd, activity, seq, flow etc...
2. Validate the database structure and elements, inluding screenshots
3. Validate the UI design
4. Validate the software code for consistency and analysis of the code using 2 static analysis tools (c# and web). Include screen shots

## PART 4

Document and report validation results
See: Original document for this.

### Application Requirements

Sydney club needs a simple membership system.

System should allow club employees to enter member details.

Future: Guests can sign-up and manage their membership online via the clubs website and via mobile app.

## Database

### Users

The users table will hold a list of employees who can add new members to the system.

* email - Valid email that acts as a unique user name
* password - hashed value that holds the users password

### Members

Members table will store member details

* First name
* Last name
* Phone number
* Date of Birth
  