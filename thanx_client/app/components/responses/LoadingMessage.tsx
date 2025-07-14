import React from 'react';
import { Message } from 'semantic-ui-react';

interface LoadingMessageProps {
  title?: string;
  message?: string;
}

export default function LoadingMessage({ 
  title = "Loading...", 
  message = "Please wait while we load your data." 
}: LoadingMessageProps) {
  return (
    <Message info>
      <Message.Header>{title}</Message.Header>
      <p>{message}</p>
    </Message>
  );
} 