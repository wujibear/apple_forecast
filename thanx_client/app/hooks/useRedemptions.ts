import { useQuery } from '@tanstack/react-query';
import { ApiService } from '../lib/api';

export const useRedemptions = () => {
  return useQuery({
    queryKey: ['redemptions'],
    queryFn: ApiService.getRedemptions,
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
    enabled: typeof window !== 'undefined' && !!localStorage.getItem('auth_token'),
    retry: (failureCount, error: any) => {
      if (error?.response?.status === 401) {
        return false;
      }
      return failureCount < 3;
    },
  });
}; 