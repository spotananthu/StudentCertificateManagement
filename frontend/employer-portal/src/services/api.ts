import axios from 'axios';

// API Gateway URL - Configurable for K8s / Prod
export const API_GATEWAY_BASE_URL =
  process.env.REACT_APP_API_GATEWAY_BASE_URL || 'http://localhost:8080';

// Get token for requests
const getToken = () => localStorage.getItem('employer_token');

// Axios client for all API calls through the gateway
const api = axios.create({
  baseURL: API_GATEWAY_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Attach JWT token
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Auto-logout on 401
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('employer_token');
      localStorage.removeItem('employer_user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;
export { api };
