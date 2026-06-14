/**
 * Generates unique values for registration tests to avoid DB conflicts.
 */
export function uniqueUsername(prefix = 'autouser') {
  return `${prefix}_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
}

export function uniqueEmail(prefix = 'auto') {
  return `${prefix}_${Date.now()}@test.bd`;
}

export function futureDate(daysAhead = 7) {
  const date = new Date();
  date.setDate(date.getDate() + daysAhead);
  return date.toISOString().split('T')[0];
}

export function getEnv(key, fallback = '') {
  return process.env[key]?.trim() || fallback;
}

export const credentials = {
  adminUsername: getEnv('ADMIN_USERNAME', 'admin'),
  adminPassword: getEnv('ADMIN_PASSWORD', 'admin'),
  seedDonorUsername: getEnv('SEED_DONOR_USERNAME', 'hamza'),
  seedDonorPassword: getEnv('SEED_DONOR_PASSWORD', ''),
  seedHospitalUsername: getEnv('SEED_HOSPITAL_USERNAME', 'dow'),
  seedHospitalPassword: getEnv('SEED_HOSPITAL_PASSWORD', ''),
};

export default credentials;
