import axios from 'axios';
import type { AxiosInstance, AxiosResponse, AxiosError } from 'axios';

// API base configuration
const API_BASE_URL = process.env.NODE_ENV === 'production' 
  ? 'https://your-api-domain.com/api/v1' 
  : 'http://localhost:3000/api/v1';

// Create axios instance with default config
const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000,
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      // Handle unauthorized - redirect to login
      localStorage.removeItem('auth_token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API response types
export interface ApiResponse<T> {
  data: T;
  message?: string;
}

export interface Reward {
  id: number;
  name: string;
  points: number;
  created_at: string;
  updated_at: string;
}

export interface User {
  id: number;
  email_address: string;
  points_balance: number;
  created_at: string;
  updated_at: string;
}

export interface Redemption {
  id: number;
  user_id: number;
  reward_id: number;
  points_cost: number;
  created_at: string;
  updated_at: string;
  user?: User;
  reward?: Reward;
}

// API service class
export class ApiService {
  // Rewards
  static async getRewards(): Promise<Reward[]> {
    const response = await apiClient.get<Reward[]>('/rewards');
    return response.data;
  }

  static async getReward(id: number): Promise<Reward> {
    const response = await apiClient.get<Reward>(`/rewards/${id}`);
    return response.data;
  }

  static async redeemReward(id: number): Promise<Redemption> {
    const response = await apiClient.post<Redemption>(`/rewards/${id}/redeem`);
    return response.data;
  }

  // Users
  static async getCurrentUser(): Promise<User> {
    const response = await apiClient.get<User>('/user');
    return response.data;
  }

  // Auth
  static async login(email: string, password: string): Promise<{ user: User; token: string }> {
    const response = await apiClient.post<{ user: User; token: string }>('/session', {
      email_address: email,
      password: password,
    });
    return response.data;
  }

  static async logout(): Promise<void> {
    await apiClient.delete('/session');
    localStorage.removeItem('auth_token');
  }
}

export default apiClient; 