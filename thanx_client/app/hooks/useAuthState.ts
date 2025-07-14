import { useAuthData, useCurrentUser } from './useAuth';

export const useAuthState = () => {
  const { data: authData, isLoading: authLoading } = useAuthData();
  const { data: userData, isLoading: userLoading, error } = useCurrentUser();

  return {
    user: userData, // Fresh data including points balance
    isLoading: authLoading || userLoading,
    isAuthenticated: !!authData, // Use auth data for authentication check
    error,
    authData // Include auth data for debugging
  };
}; 