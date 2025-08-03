import { useQuery } from '@tanstack/react-query';
import { ApiService } from '../lib/api';
import { useLocalStorage } from './useAuth';

export const useRedemptions = () => {
  const { hasToken, isClient } = useLocalStorage();

  return useQuery({
    queryKey: ['redemptions'],
    queryFn: ApiService.getRedemptions,
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
    enabled: isClient && hasToken,
    retry: (failureCount, error: any) => {
      if (error?.response?.status === 401) {
        return false;
      }
      return failureCount < 3;
    },
  });
};
