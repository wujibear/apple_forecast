import { useMutation, useQueryClient, useQuery } from '@tanstack/react-query';
import { ApiService } from '../lib/api';
import { useState, useEffect } from 'react';

interface LoginCredentials {
  email: string;
  password: string;
}

// Client-only hook for localStorage access
export function useLocalStorage() {
  const [hasToken, setHasToken] = useState(false);
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
    setHasToken(!!localStorage.getItem('auth_token'));
  }, []);

  const setToken = (token: string) => {
    if (isClient) {
      localStorage.setItem('auth_token', token);
      setHasToken(true);
    }
  };

  const removeToken = () => {
    if (isClient) {
      localStorage.removeItem('auth_token');
      setHasToken(false);
    }
  };

  return { hasToken, setToken, removeToken, isClient };
}

// Hook for authentication data (persistent)
export const useAuthData = () => {
  const { hasToken, isClient } = useLocalStorage();
  
  return useQuery({
    queryKey: ['auth'],
    queryFn: ApiService.getCurrentUser,
    staleTime: 10 * 60 * 1000, // 10 minutes - auth data doesn't change often
    gcTime: 30 * 60 * 1000, // 30 minutes
    enabled: isClient && hasToken,
    retry: (failureCount, error: any) => {
      if (error?.response?.status === 401) {
        // Clear invalid token
        if (typeof window !== 'undefined') {
          localStorage.removeItem('auth_token');
        }
        return false;
      }
      return failureCount < 3;
    },
    select: (data) => ({
      id: data.id,
      email_address: data.email_address,
      created_at: data.created_at,
      updated_at: data.updated_at
    }),
    // Ensure this query is persisted
    meta: {
      persist: true
    }
  });
};

// Hook for fresh user data (including points balance)
export const useCurrentUser = () => {
  const { hasToken, isClient } = useLocalStorage();
  
  return useQuery({
    queryKey: ['user'],
    queryFn: ApiService.getCurrentUser,
    staleTime: 0, // Always fetch fresh data
    gcTime: 0, // Don't persist user data
    enabled: isClient && hasToken,
    retry: (failureCount, error: any) => {
      if (error?.response?.status === 401) {
        return false;
      }
      return failureCount < 3;
    },
  });
};

export const useLogin = () => {
  const queryClient = useQueryClient();
  const { setToken } = useLocalStorage();

  return useMutation({
    mutationFn: (credentials: LoginCredentials) => 
      ApiService.login(credentials.email, credentials.password),
    onSuccess: (data) => {
      // Store the session token
      setToken(data.token);
      
      // Set authentication data (email, id, etc.)
      const authData = {
        id: data.user.id,
        email_address: data.user.email_address,
        created_at: data.user.created_at,
        updated_at: data.user.updated_at
      };
      queryClient.setQueryData(['auth'], authData);
      
      // Set fresh user data including points
      queryClient.setQueryData(['user'], data.user);
      
      // Invalidate user query to ensure fresh data on next fetch
      queryClient.invalidateQueries({ queryKey: ['user'] });
      
      // Also invalidate auth query to ensure it's properly cached
      queryClient.invalidateQueries({ queryKey: ['auth'] });
      
      // Invalidate redemptions query to ensure fresh data
      queryClient.invalidateQueries({ queryKey: ['redemptions'] });
    },
    onError: (error: any) => {
      console.error('Login failed:', error);
    },
  });
};

export const useLogout = () => {
  const queryClient = useQueryClient();
  const { removeToken } = useLocalStorage();

  return useMutation({
    mutationFn: ApiService.logout,
    onSuccess: () => {
      // Clear the session token
      removeToken();
      
      // Clear all user-related data from cache
      queryClient.setQueryData(['auth'], null);
      queryClient.setQueryData(['user'], null);
      queryClient.invalidateQueries({ queryKey: ['user'] });
      queryClient.invalidateQueries({ queryKey: ['auth'] });
    },
    onError: (error: any) => {
      console.error('Logout failed:', error);
      // Even if logout fails on server, clear local data
      removeToken();
      queryClient.setQueryData(['auth'], null);
      queryClient.setQueryData(['user'], null);
    },
  });
}; 