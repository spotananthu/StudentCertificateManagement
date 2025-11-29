import axios, { AxiosResponse, AxiosError } from 'axios';
import { Certificate, CertificateIssueRequest, CertificateUpdateRequest, CertificateRevocationRequest, FileUploadResponse } from '../types/certificate';

// API Base URL - should be configured via environment variables
const API_GATEWAY_BASE_URL = process.env.REACT_APP_API_GATEWAY_BASE_URL || 'http://localhost:9090';

// Create axios instance with common configuration
const apiClient = axios.create({
  baseURL: API_GATEWAY_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
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

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      // Handle unauthorized access
      localStorage.removeItem('student_token');
      localStorage.removeItem('student_user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export class CertificateService {
  /**
   * Get all certificates for the current student
   */
  static async getCertificates(status?: string): Promise<Certificate[]> {
    try {
      const params = status ? { status } : {};
      const response: AxiosResponse<Certificate[]> = await apiClient.get('/certificates', { params });
      return response.data;
    } catch (error) {
      console.error('Error fetching certificates:', error);
      throw error;
    }
  }

  /**
   * Get a specific certificate by ID
   */
  static async getCertificateById(id: string): Promise<Certificate> {
    try {
      const response: AxiosResponse<Certificate> = await apiClient.get(`/certificates/${id}`);
      return response.data;
    } catch (error) {
      console.error('Error fetching certificate:', error);
      throw error;
    }
  }

  /**
   * Issue a new certificate (admin/university use)
   */
  static async issueCertificate(request: CertificateIssueRequest): Promise<Certificate> {
    try {
      const response: AxiosResponse<Certificate> = await apiClient.post('/certificates', request);
      return response.data;
    } catch (error) {
      console.error('Error issuing certificate:', error);
      throw error;
    }
  }

  /**
   * Update an existing certificate
   */
  static async updateCertificate(id: string, request: CertificateUpdateRequest): Promise<Certificate> {
    try {
      const response: AxiosResponse<Certificate> = await apiClient.put(`/certificates/${id}`, request);
      return response.data;
    } catch (error) {
      console.error('Error updating certificate:', error);
      throw error;
    }
  }

  /**
   * Revoke a certificate
   */
  static async revokeCertificate(request: CertificateRevocationRequest): Promise<string> {
    try {
      const response: AxiosResponse<string> = await apiClient.post('/certificates/revoke', request);
      return response.data;
    } catch (error) {
      console.error('Error revoking certificate:', error);
      throw error;
    }
  }

  /**
   * Download certificate PDF
   */
  static async downloadCertificatePdf(certificateId: string): Promise<Blob> {
    try {
      const response: AxiosResponse<Blob> = await apiClient.get(`/certificates/${certificateId}/pdf`, {
        responseType: 'blob',
      });
      return response.data;
    } catch (error) {
      console.error('Error downloading certificate PDF:', error);
      throw error;
    }
  }

  /**
   * Upload a file (for admin/university use)
   */
  static async uploadFile(file: File, type: string): Promise<FileUploadResponse> {
    try {
      const formData = new FormData();
      formData.append('file', file);
      formData.append('type', type);

      const response: AxiosResponse<FileUploadResponse> = await apiClient.post('/certificates/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
      return response.data;
    } catch (error) {
      console.error('Error uploading file:', error);
      throw error;
    }
  }

  /**
   * Batch issue certificates (admin/university use)
   */
  static async batchIssueCertificates(certificates: CertificateIssueRequest[]): Promise<any> {
    try {
      const response = await apiClient.post('/certificates/batch-issue', {
        'static/certificates': certificates
      });
      return response.data;
    } catch (error) {
      console.error('Error batch issuing certificates:', error);
      throw error;
    }
  }
}

export default CertificateService;