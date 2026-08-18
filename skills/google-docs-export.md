# Google Docs Export

Walk the user through getting resumes out of Google Drive and into
`resume-archive/`.

Use this when the user's Archived Resumes live in Google Docs, Drive, or "the
cloud".

This is guidance only. This kit has no Google integration, asks for no account
access, and never signs in on the user's behalf. They do the export; you help
them aim it and then handle the files once they land.

## Which route

Ask how many files and whether they are gathered in one place.

- **A handful, or all in one folder** — the Drive route below. Immediate.
- **Scattered across years, and they want everything** — the Takeout route.
  Slower, and the only one that sweeps a whole Drive.

Lead with the Drive route. Most people have four to ten resumes in one folder
and Takeout is a heavy answer to a light question.

## The Drive route

Tell them:

1. Open `drive.google.com` and search for `resume` or `CV`. Their old resumes
   are usually named something with one of those words in it.
2. Select the ones they want. Click the first, then hold **Shift** for a range
   or **Cmd/Ctrl** for individual files.
3. Right-click the selection and choose **Download**.
4. Google converts each Doc to `.docx` on the way out, and more than one file
   arrives as a single `.zip`.

Then take over: the download lands in their Downloads folder, and you can move
and unzip it into `resume-archive/` yourself once they tell you it finished.
Ask before moving anything, and confirm the filenames you are about to move.

## The Takeout route

For the person with a decade of files in no particular order.

1. Open `takeout.google.com`.
2. **Deselect all**, then select **Drive** alone. The default is every Google
   product they have ever used, which is gigabytes they do not need.
3. Inside Drive, narrow to the folders holding resumes if they can. Under the
   format options, set documents to export as `.docx`.
4. Request the export once, delivered as a download link by email.
5. Wait. Small exports arrive in minutes; large ones take hours. Tell them this
   up front, because a Takeout that has not arrived looks like a broken step.

When the archive lands, the files sit several folders deep, in the shape
`Takeout/Drive/<their folder path>/<file>.docx`. Unzip it and flatten the
resumes into `resume-archive/` for them, then report what you moved.

## Once the files are in place

Return to `skills/start.md` and continue with the archive path.

If the Google UI does not match what is written here, trust what the user is
looking at and adapt. These screens change and this document does not.
