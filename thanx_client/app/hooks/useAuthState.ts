import { useCurrentUser } from './useUser';

export const useAuthState = () => {
  const { data: user, isLoading, error } = useCurrentUser();

  return {
    user,
    isLoading,
    isAuthenticated: !!user,
    error
  };
}; 