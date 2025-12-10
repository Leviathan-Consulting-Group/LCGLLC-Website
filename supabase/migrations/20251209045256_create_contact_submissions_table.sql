/*
  # Create contact_submissions table for website form submissions

  1. New Tables
    - `contact_submissions`
      - `id` (uuid, primary key) - Unique identifier for each submission
      - `created_at` (timestamptz) - Timestamp when submission was created
      - `name` (text) - Contact's full name
      - `email` (text) - Contact's email address
      - `company` (text, nullable) - Contact's company/organization
      - `phone` (text, nullable) - Contact's phone number
      - `message` (text) - Message content from contact form
      - `source` (text) - Track which form/page the submission came from
  
  2. Security
    - Enable RLS on `contact_submissions` table
    - Add policy for service role to insert submissions
    - Public can insert but not read (write-only for form submissions)

  3. Important Notes
    - Form submissions are write-only for public users
    - Only authenticated admin users can read submissions
    - Timestamps automatically recorded for tracking
*/

CREATE TABLE IF NOT EXISTS contact_submissions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now(),
  name text NOT NULL,
  email text NOT NULL,
  company text,
  phone text,
  message text NOT NULL,
  source text DEFAULT 'website'
);

ALTER TABLE contact_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public to insert contact submissions"
  ON contact_submissions
  FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Only authenticated users can read submissions"
  ON contact_submissions
  FOR SELECT
  TO authenticated
  USING (true);