class AppConfig {
  AppConfig._();

  // Override at build time with --dart-define=SUPABASE_URL=https://xxx.supabase.co
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://peirjdldxnxpudhnfrlm.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlaXJqZGxkeG54cHVkaG5mcmxtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE1NDg3MzcsImV4cCI6MjA5NzEyNDczN30.GnQBfmR_HLDM8gsjjrjJvjQAgMrIOxR8sAlKfPGxudI',
  );
}
