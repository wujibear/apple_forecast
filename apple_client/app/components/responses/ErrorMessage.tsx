import React from 'react';
import { Message } from 'semantic-ui-react';

interface ErrorMessageProps {
  title?: string;
  message?: string;
}

export default function ErrorMessage({
  title = 'Error',
  message = 'There was an error loading your data. Please try again.',
}: ErrorMessageProps) {
  return (
    <Message negative>
      <Message.Header>{title}</Message.Header>
      <p>{message}</p>
    </Message>
  );
}
