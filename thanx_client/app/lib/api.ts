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
    if (typeof window !== 'undefined') {
      const token = localStorage.getItem('auth_token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
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
      if (typeof window !== 'undefined') {
        localStorage.removeItem('auth_token');
        window.location.href = '/login';
      }
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
  nanoid: string;
  name: string;
  points: number;
  created_at: string;
  updated_at: string;
}

export interface User {
  nanoid: string;
  email_address: string;
  points_balance: number;
  created_at: string;
  updated_at: string;
}

export interface Redemption {
  nanoid: string;
  user_nanoid: string;
  reward_nanoid: string;
  reward_name: string;
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

  static async getReward(nanoid: string): Promise<Reward> {
    const response = await apiClient.get<Reward>(`/rewards/${nanoid}`);
    return response.data;
  }

  static async redeemReward(nanoid: string): Promise<Redemption> {
    const response = await apiClient.post<Redemption>(`/rewards/${nanoid}/redeem`);
    return response.data;
  }

  // Users
  static async getCurrentUser(): Promise<User> {
    const response = await apiClient.get<User>('/user');
    return response.data;
  }

  // Redemptions
  static async getRedemptions(): Promise<Redemption[]> {
    const response = await apiClient.get<Redemption[]>('/redemptions');
    return response.data;
  }

  // Auth
  static async login(email: string, password: string): Promise<{ user: User; token: string }> {
    const response = await apiClient.post<User>('/session', {
      email_address: email,
      password: password,
    });
    
    // Extract token from response headers
    const token = response.headers['x-session-token'] || response.headers['X-Session-Token'];
    
    return {
      user: response.data,
      token: token || ''
    };
  }

  static async logout(): Promise<void> {
    await apiClient.delete('/session');
    if (typeof window !== 'undefined') {
      localStorage.removeItem('auth_token');
    }
  }
}

export default apiClient; 