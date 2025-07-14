import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { ApiService } from '../lib/api';
import type { Reward, Redemption } from '../lib/api';

// Query keys
export const rewardKeys = {
  all: ['rewards'] as const,
  lists: () => [...rewardKeys.all, 'list'] as const,
  list: (filters: string) => [...rewardKeys.lists(), { filters }] as const,
  details: () => [...rewardKeys.all, 'detail'] as const,
  detail: (nanoid: string) => [...rewardKeys.details(), nanoid] as const,
};

// Hooks
export const useRewards = () => {
  return useQuery({
    queryKey: rewardKeys.lists(),
    queryFn: ApiService.getRewards,
  });
};

export const useReward = (nanoid: string) => {
  return useQuery({
    queryKey: rewardKeys.detail(nanoid),
    queryFn: () => ApiService.getReward(nanoid),
    enabled: !!nanoid,
  });
};

export const useRedeemReward = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (rewardNanoid: string) => ApiService.redeemReward(rewardNanoid),
    onSuccess: (data, rewardNanoid) => {
      // Invalidate and refetch rewards list
      queryClient.invalidateQueries({ queryKey: rewardKeys.lists() });

      // Invalidate user data to refresh points balance
      queryClient.invalidateQueries({ queryKey: ['user'] });

      // Optionally update the specific reward if it has redemption count
      queryClient.invalidateQueries({
        queryKey: rewardKeys.detail(rewardNanoid),
      });
    },
    onError: (error: any) => {
      console.error('Failed to redeem reward:', error);
    },
  });
};
