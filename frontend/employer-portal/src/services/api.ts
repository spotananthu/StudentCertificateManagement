import axios from 'axios';

// Get token for requests
const getToken = () => localStorage.getItem('employer_token');

// API Gateway URL - All requests will go through the gateway
const API_GATEWAY_BASE_URL = process.env.REACT_APP_API_GATEWAY_BASE_URL || 'http://localhost:9090';

// Create main API instance for all endpoints (routes through API Gateway)
const api = axios.create({
  baseURL: API_GATEWAY_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle response errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - clear auth data
      localStorage.removeItem('employer_token');
      localStorage.removeItem('employer_user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export { api };
export default api;
