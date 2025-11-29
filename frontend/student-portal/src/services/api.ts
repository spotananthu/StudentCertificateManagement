import axios from 'axios';

// API Gateway URL - All requests will go through the gateway
const API_GATEWAY_BASE_URL = process.env.REACT_APP_API_GATEWAY_BASE_URL || 'http://localhost:9090';

// Create main API instance for all endpoints (routes through API Gateway)
const api = axios.create({
  baseURL: API_GATEWAY_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000,
});

// Add request interceptor to include auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('student_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Add response interceptor to handle auth errors
api.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid, clear auth data
      localStorage.removeItem('student_token');
      localStorage.removeItem('student_user');
      // Redirect to login page
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;