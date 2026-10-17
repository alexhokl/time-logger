---
name: log-time
description: Log time in the Time Logger app. Use this when the user says they worked on, spent time on or finished something, wants to log or record time, wants to start a timer for a task, or wants to open their time entries or reports.
metadata:
  homepage: https://github.com/alexhokl/time-logger/tree/main/google-ai-edge-gallery-skills/log-time
---

# Log time

## Instructions

The Time Logger app opens a pre-filled form from a link. Your job is to build
that link and show it to the user so they can tap it. The app never saves
anything until the user taps Start or Save.

### Starting a timer or logging an entry

1. Decide the `mode`:
   - `timer` when the user is starting work now, e.g. "start a timer for the
     code review" or "I'm starting on the acme API".
   - `entry` when the work is already done, e.g. "I spent 90 minutes on code
     review" or "standup from 9:00 to 9:15 yesterday".
2. Identify the following from the user's message:
   - `description`: a short description of the work, e.g. "Code review".
   - `project`: the project name, if the user mentions one, e.g. "acme".
   - `task`: the task name, if the user mentions one.
   - `tags`: a list of tags, if the user mentions any, e.g. ["billable"].
   - For `entry` mode only:
     - `duration`: how long, e.g. "90", "1h30m" or "2h". A bare number is
       minutes.
     - `start` and `end`: 24-hour times as HH:MM, if the user gives them.
     - `date`: the day as YYYY-MM-DD. Leave it out for today. If the user
       gives a relative date such as "yesterday" or "last Friday", first call
       the `run_intent` tool with intent `get_current_date_and_time` and
       parameters `{}`, then work out the date from the result.
3. Call the `run_js` tool with the following exact parameters:
   - script name: index.html
   - data: A JSON string with the following fields:
     - mode: String. "timer" or "entry". Required.
     - description: String. Optional.
     - project: String. Optional.
     - task: String. Optional.
     - tags: Array of strings. Optional.
     - duration: String. Optional, entry mode only.
     - start: String. HH:MM. Optional, entry mode only.
     - end: String. HH:MM. Optional, entry mode only.
     - date: String. YYYY-MM-DD. Optional, entry mode only.
4. Reply with the returned link as a markdown link, exactly as returned, for
   example:

   [Open entry form](timelogger://entry/new?description=Code%20review&project=acme&duration=90)

   Briefly list what will be filled in. Do not say the time has been logged
   or the timer started; the user does that in the app.

### Opening entries or reports

When the user wants to see their entries or reports, do not call any tool.
Reply with one of these markdown links:

- [Open entries](timelogger://entries)
- [Open reports](timelogger://reports)

### Sample commands

- "Start a timer for the acme code review"
- "I spent 90 minutes on code review for acme"
- "Log standup yesterday from 9:00 to 9:15, tag it meetings"
- "Worked 2 hours on the API task of project acme, billable"
- "Show my time reports"
