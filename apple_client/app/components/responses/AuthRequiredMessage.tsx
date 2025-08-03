import React from 'react';
import { Message } from 'semantic-ui-react';

interface AuthRequiredMessageProps {
  title?: string;
  message?: string;
}

export default function AuthRequiredMessage({
  title = 'Authentication Required',
  message = 'Please sign in to view this content.',
}: AuthRequiredMessageProps) {
  return (
    <Message warning>
      <Message.Header>{title}</Message.Header>
      <p>{message}</p>
    </Message>
  );
}
