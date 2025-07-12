import { useQuery } from '@tanstack/react-query';
import { ApiService } from '../lib/api';
import type { User } from '../lib/api';

export const useCurrentUser = () => {
  return useQuery({
    queryKey: ['user'],
    queryFn: ApiService.getCurrentUser,
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
}; 