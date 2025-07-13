import { useQuery } from '@tanstack/react-query';
import { ApiService } from '../lib/api';
import type { User } from '../lib/api';

export const useCurrentUser = () => {
  return useQuery({
    queryKey: ['user'],
    queryFn: ApiService.getCurrentUser,
    staleTime: 2 * 60 * 1000, // 2 minutes
    enabled: typeof window !== 'undefined' && !!localStorage.getItem('auth_token'), // Only run if we have a token
    retry: (failureCount, error: any) => {
      // Don't retry on 401 errors (invalid token)
      if (error?.response?.status === 401) {
        return false;
      }
      return failureCount < 3;
    },
  });
}; 