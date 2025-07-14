import { describe, it, expect } from 'vitest';

describe('Example Test', () => {
  it('should work', () => {
    expect(1 + 1).toBe(2);
  });

  it('should have access to DOM matchers', () => {
    const element = document.createElement('div');
    element.textContent = 'Hello World';
    document.body.appendChild(element);

    expect(element).toBeInTheDocument();
    expect(element).toHaveTextContent('Hello World');
  });
});
