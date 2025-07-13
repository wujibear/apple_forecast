import { useMutation, useQueryClient } from '@tanstack/react-query';
import { ApiService } from '../lib/api';

interface LoginCredentials {
  email: string;
  password: string;
}

export const useLogin = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (credentials: LoginCredentials) => 
      ApiService.login(credentials.email, credentials.password),
    onSuccess: (data) => {
      // Store the session token
      if (typeof window !== 'undefined') {
        localStorage.setItem('auth_token', data.token);
      }
      
      // Invalidate and refetch user data
      queryClient.invalidateQueries({ queryKey: ['user'] });
      
      // Set the user data in cache
      queryClient.setQueryData(['user'], data.user);
    },
    onError: (error: any) => {
      console.error('Login failed:', error);
    },
  });
};

export const useLogout = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ApiService.logout,
    onSuccess: () => {
      // Clear the session token
      if (typeof window !== 'undefined') {
        localStorage.removeItem('auth_token');
      }
      
      // Clear user data from cache
      queryClient.setQueryData(['user'], null);
      queryClient.invalidateQueries({ queryKey: ['user'] });
    },
    onError: (error: any) => {
      console.error('Logout failed:', error);
      // Even if logout fails on server, clear local data
      if (typeof window !== 'undefined') {
        localStorage.removeItem('auth_token');
      }
      queryClient.setQueryData(['user'], null);
    },
  });
}; 