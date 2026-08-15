export interface HealthStatus {
  status: 'up' | 'down';
}

export interface UserSession {
  id: string;
  isGuest: boolean;
  locale: string;
}
