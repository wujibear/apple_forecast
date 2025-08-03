import React from 'react';
import {
  Menu,
  Container,
  Button,
  Dropdown,
  Icon,
  Modal,
  Form,
  Message,
} from 'semantic-ui-react';
import { Link, useLocation } from 'react-router';
import { useAuthState } from '../hooks/useAuthState';
import { useLogin, useLogout } from '../hooks/useAuth';

interface LayoutProps {
  children: React.ReactNode;
}

export default function Layout({ children }: LayoutProps) {
  const { user, isLoading, isAuthenticated } = useAuthState();
  const {
    mutate: login,
    isPending: isLoggingIn,
    error: loginError,
  } = useLogin();
  const { mutate: logout, isPending: isLoggingOut } = useLogout();
  const [isLoginModalOpen, setIsLoginModalOpen] = React.useState(false);
  const [loginForm, setLoginForm] = React.useState({ email: '', password: '' });
  const location = useLocation();

  const handleLogin = () => {
    login(loginForm, {
      onSuccess: () => {
        setIsLoginModalOpen(false);
        setLoginForm({ email: '', password: '' });
      },
    });
  };

  const handleLogout = () => {
    logout();
  };

  const handleInputChange = (field: string, value: string) => {
    setLoginForm(prev => ({ ...prev, [field]: value }));
  };

  return (
    <div>
      <Menu fixed="top" inverted>
        <Container>
          <Menu.Item header as={Link} to="/">
            <Icon name="gift" />
            Apple Rewards
          </Menu.Item>

          {isAuthenticated && (
            <>
              <Menu.Item
                as={Link}
                to="/rewards"
                active={location.pathname === '/rewards'}
              >
                <Icon name="gift" />
                Rewards
              </Menu.Item>
              <Menu.Item
                as={Link}
                to="/claimed-rewards"
                active={location.pathname === '/claimed-rewards'}
              >
                <Icon name="clock" />
                History
              </Menu.Item>
            </>
          )}

          <Menu.Menu position="right">
            {isLoading ? (
              <Menu.Item>
                <Icon loading name="spinner" />
              </Menu.Item>
            ) : user ? (
              <Menu.Item>
                <Dropdown
                  trigger={
                    <span>
                      <Icon name="user" />
                      {user.email_address}
                    </span>
                  }
                  pointing="top right"
                >
                  <Dropdown.Menu>
                    <Dropdown.Item disabled>
                      <Icon name="dollar" />
                      {user.points_balance.toLocaleString()} points
                    </Dropdown.Item>
                    <Dropdown.Divider />
                    <Dropdown.Item
                      onClick={handleLogout}
                      disabled={isLoggingOut}
                    >
                      <Icon name="sign-out" />
                      Log Out
                    </Dropdown.Item>
                  </Dropdown.Menu>
                </Dropdown>
              </Menu.Item>
            ) : (
              <Menu.Item>
                <Button
                  icon
                  labelPosition="left"
                  onClick={() => setIsLoginModalOpen(true)}
                >
                  <Icon name="sign-in" />
                  Sign In
                </Button>
              </Menu.Item>
            )}
          </Menu.Menu>
        </Container>
      </Menu>

      <Container style={{ marginTop: '5rem', marginBottom: '2rem' }}>
        {children}
      </Container>

      {/* Login Modal */}
      <Modal
        open={isLoginModalOpen}
        onClose={() => setIsLoginModalOpen(false)}
        size="tiny"
      >
        <Modal.Header>Sign In</Modal.Header>
        <Modal.Content>
          <Form>
            <Form.Field>
              <label>Email</label>
              <Form.Input
                type="email"
                value={loginForm.email}
                onChange={e => handleInputChange('email', e.target.value)}
                placeholder="Enter your email"
              />
            </Form.Field>
            <Form.Field>
              <label>Password</label>
              <Form.Input
                type="password"
                value={loginForm.password}
                onChange={e => handleInputChange('password', e.target.value)}
                placeholder="Enter your password"
              />
            </Form.Field>
            {loginError && (
              <Message negative>
                <Message.Header>Login Failed</Message.Header>
                <p>{loginError.message}</p>
              </Message>
            )}
          </Form>
        </Modal.Content>
        <Modal.Actions>
          <Button onClick={() => setIsLoginModalOpen(false)}>Cancel</Button>
          <Button
            primary
            onClick={handleLogin}
            loading={isLoggingIn}
            disabled={!loginForm.email || !loginForm.password}
          >
            Sign In
          </Button>
        </Modal.Actions>
      </Modal>
    </div>
  );
}
