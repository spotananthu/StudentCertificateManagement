import React, { useState, useEffect, useCallback } from 'react';
import {
  Container,
  Typography,
  Box,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Chip,
  IconButton,
  TextField,
  InputAdornment,
  Card,
  CardContent,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Alert,
  Pagination,
  Tooltip,
  Grid,
} from '@mui/material';
import {
  Search,
  Visibility,
  Download,
  FilterList,
  Cancel,
  Refresh,
  VerifiedUser,
  School,
  Person,
} from '@mui/icons-material';
import { adminService } from '../services';
import { Certificate, PaginatedResponse } from '../types';
import { format } from 'date-fns';

export const CertificateManagement: React.FC = () => {
  const [certificates, setCertificates] = useState<PaginatedResponse<Certificate> | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [degreeFilter, setDegreeFilter] = useState('all');
  const [page, setPage] = useState(1);
  const [viewCertificate, setViewCertificate] = useState<Certificate | null>(null);
  const [revoking, setRevoking] = useState(false);
  const [revokeReason, setRevokeReason] = useState('');

  const loadCertificates = useCallback(async () => {
    try {
      setLoading(true);
      setError(null); // Clear any previous errors
      const filters: any = {};
      
      if (searchTerm) {
        filters.search = searchTerm;
      }
      if (statusFilter !== 'all') {
        filters.isRevoked = statusFilter === 'revoked';
      }
      if (degreeFilter !== 'all') {
        filters.degreeType = degreeFilter;
      }

      const data = await adminService.getCertificates(page, 20, filters);
      setCertificates(data);
    } catch (err: any) {
      console.error('Failed to load certificates:', err);
      if (err.message?.includes('connect')) {
        setError('Unable to connect to the certificate service. Please ensure the backend services are running.');
      } else {
        setError(err.message || 'Failed to load certificates. Please try again.');
      }
      // Don't clear existing certificates on error, keep showing what we had
    } finally {
      setLoading(false);
    }
  }, [page, searchTerm, statusFilter, degreeFilter]);

  useEffect(() => {
    loadCertificates();
  }, [loadCertificates]);

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(event.target.value);
    setPage(1);
  };

  const handleStatusFilterChange = (event: any) => {
    setStatusFilter(event.target.value);
    setPage(1);
  };

  const handleDegreeFilterChange = (event: any) => {
    setDegreeFilter(event.target.value);
    setPage(1);
  };

  const handlePageChange = (_: React.ChangeEvent<unknown>, newPage: number) => {
    setPage(newPage);
  };

  const handleViewCertificate = (certificate: Certificate) => {
    setViewCertificate(certificate);
  };

  const handleRevokeCertificate = async () => {
    if (!viewCertificate || !revokeReason.trim()) return;

    try {
      setRevoking(true);
      // Use the verification code or certificate number for revocation
      const certificateIdentifier = viewCertificate.verificationCode || viewCertificate.id;
      await adminService.revokeCertificate(certificateIdentifier, revokeReason);
      setSuccessMessage('Certificate revoked successfully');
      setViewCertificate(null);
      setRevokeReason('');
      // Reload certificates to reflect the change
      await loadCertificates();
    } catch (err: any) {
      console.error('Failed to revoke certificate:', err);
      if (err.message?.includes('connect')) {
        setError('Unable to connect to the certificate service. Please ensure the backend services are running.');
      } else {
        setError(err.message || 'Failed to revoke certificate. Please try again.');
      }
    } finally {
      setRevoking(false);
    }
  };

  const handleExportCertificates = () => {
    // TODO: Implement certificate export functionality
    console.log('Export certificates');
  };

  const getStatusColor = (isRevoked: boolean) => {
    return isRevoked ? 'error' : 'success';
  };

  const getGradeColor = (grade: string) => {
    const gradeUpper = grade.toUpperCase();
    if (['A+', 'A', 'DISTINCTION'].includes(gradeUpper)) return 'success';
    if (['B+', 'B', 'FIRST CLASS'].includes(gradeUpper)) return 'primary';
    if (['C+', 'C', 'SECOND CLASS'].includes(gradeUpper)) return 'warning';
    return 'default';
  };

  const displayCertificates = certificates?.content || [];

  return (
    <Container maxWidth="xl" sx={{ pt: 4 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4" component="h1">
          Certificate Management
        </Typography>
        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button
            variant="outlined"
            startIcon={<Refresh />}
            onClick={loadCertificates}
            disabled={loading}
          >
            Refresh
          </Button>
          <Button
            variant="contained"
            startIcon={<Download />}
            onClick={handleExportCertificates}
          >
            Export Certificates
          </Button>
        </Box>
      </Box>

      {error && (
        <Alert severity="error" sx={{ mb: 3 }} onClose={() => setError(null)}>
          {error}
          {error.includes('connect') && (
            <Typography variant="body2" sx={{ mt: 1, fontStyle: 'italic' }}>
              The system will fall back to mock data for demonstration purposes.
            </Typography>
          )}
        </Alert>
      )}

      {successMessage && (
        <Alert severity="success" sx={{ mb: 3 }} onClose={() => setSuccessMessage(null)}>
          {successMessage}
        </Alert>
      )}

      {/* Stats Cards */}
      <Grid container spacing={3} sx={{ mb: 3 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <School color="primary" sx={{ mr: 2 }} />
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Total Certificates
                  </Typography>
                  <Typography variant="h5">
                    {certificates?.totalElements || 0}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <VerifiedUser color="success" sx={{ mr: 2 }} />
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Active Certificates
                  </Typography>
                  <Typography variant="h5">
                    {displayCertificates.filter(cert => !cert.isRevoked).length}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Cancel color="error" sx={{ mr: 2 }} />
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Revoked Certificates
                  </Typography>
                  <Typography variant="h5">
                    {displayCertificates.filter(cert => cert.isRevoked).length}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Box sx={{ display: 'flex', alignItems: 'center' }}>
                <Person color="info" sx={{ mr: 2 }} />
                <Box>
                  <Typography color="textSecondary" gutterBottom>
                    Universities
                  </Typography>
                  <Typography variant="h5">
                    {new Set(displayCertificates.map(cert => cert.university.id)).size}
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Filters */}
      <Card sx={{ mb: 3 }}>
        <CardContent>
          <Box sx={{ display: 'flex', gap: 2, flexWrap: 'wrap' }}>
            <TextField
              placeholder="Search certificates..."
              value={searchTerm}
              onChange={handleSearch}
              sx={{ minWidth: 300 }}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Search />
                  </InputAdornment>
                ),
              }}
            />
            <FormControl sx={{ minWidth: 150 }}>
              <InputLabel>Status</InputLabel>
              <Select
                value={statusFilter}
                label="Status"
                onChange={handleStatusFilterChange}
                startAdornment={<FilterList sx={{ mr: 1 }} />}
              >
                <MenuItem value="all">All Status</MenuItem>
                <MenuItem value="active">Active</MenuItem>
                <MenuItem value="revoked">Revoked</MenuItem>
              </Select>
            </FormControl>
            <FormControl sx={{ minWidth: 150 }}>
              <InputLabel>Degree Type</InputLabel>
              <Select
                value={degreeFilter}
                label="Degree Type"
                onChange={handleDegreeFilterChange}
                startAdornment={<FilterList sx={{ mr: 1 }} />}
              >
                <MenuItem value="all">All Degrees</MenuItem>
                <MenuItem value="Bachelor">Bachelor</MenuItem>
                <MenuItem value="Master">Master</MenuItem>
                <MenuItem value="PhD">PhD</MenuItem>
                <MenuItem value="Diploma">Diploma</MenuItem>
              </Select>
            </FormControl>
          </Box>
        </CardContent>
      </Card>

      {/* Certificates Table */}
      <Card>
        <CardContent>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Certificate ID</TableCell>
                  <TableCell>Student</TableCell>
                  <TableCell>Course</TableCell>
                  <TableCell>University</TableCell>
                  <TableCell>Grade</TableCell>
                  <TableCell>Issue Date</TableCell>
                  <TableCell>Status</TableCell>
                  <TableCell>Actions</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={8} sx={{ textAlign: 'center', py: 3 }}>
                      Loading certificates...
                    </TableCell>
                  </TableRow>
                ) : displayCertificates.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={8} align="center">
                      No certificates found
                    </TableCell>
                  </TableRow>
                ) : (
                  displayCertificates.map((certificate) => (
                    <TableRow key={certificate.id}>
                      <TableCell>
                        <Typography variant="body2" color="primary">
                          {certificate.verificationCode}
                        </Typography>
                      </TableCell>
                      <TableCell>
                        <Box>
                          <Typography variant="body2" fontWeight="medium">
                            {certificate.studentName}
                          </Typography>
                          <Typography variant="caption" color="textSecondary">
                            ID: {certificate.studentId}
                          </Typography>
                        </Box>
                      </TableCell>
                      <TableCell>
                        <Box>
                          <Typography variant="body2" fontWeight="medium">
                            {certificate.course}
                          </Typography>
                          <Typography variant="caption" color="textSecondary">
                            {certificate.degreeType}
                          </Typography>
                        </Box>
                      </TableCell>
                      <TableCell>
                        <Typography variant="body2">
                          {certificate.university.name}
                        </Typography>
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={certificate.grade}
                          color={getGradeColor(certificate.grade) as any}
                          size="small"
                        />
                      </TableCell>
                      <TableCell>
                        {format(new Date(certificate.issueDate), 'MMM dd, yyyy')}
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={certificate.isRevoked ? 'Revoked' : 'Active'}
                          color={getStatusColor(certificate.isRevoked) as any}
                          size="small"
                        />
                      </TableCell>
                      <TableCell>
                        <Tooltip title="View details">
                          <IconButton
                            size="small"
                            onClick={() => handleViewCertificate(certificate)}
                            color="primary"
                          >
                            <Visibility />
                          </IconButton>
                        </Tooltip>
                        {!certificate.isRevoked && (
                          <Tooltip title="Revoke certificate">
                            <IconButton
                              size="small"
                              onClick={() => handleViewCertificate(certificate)}
                              color="error"
                            >
                              <Cancel />
                            </IconButton>
                          </Tooltip>
                        )}
                      </TableCell>
                    </TableRow>
                  ))
                )}
              </TableBody>
            </Table>
          </TableContainer>

          {certificates && certificates.totalPages && certificates.totalPages > 1 && (
            <Box sx={{ display: 'flex', justifyContent: 'center', mt: 3 }}>
              <Pagination
                count={certificates.totalPages}
                page={page}
                onChange={handlePageChange}
                color="primary"
              />
            </Box>
          )}
        </CardContent>
      </Card>

      {/* Certificate Details Dialog */}
      <Dialog
        open={!!viewCertificate}
        onClose={() => setViewCertificate(null)}
        maxWidth="md"
        fullWidth
      >
        <DialogTitle>
          Certificate Details
          {viewCertificate && (
            <Chip
              label={viewCertificate.isRevoked ? 'Revoked' : 'Active'}
              color={getStatusColor(viewCertificate.isRevoked) as any}
              size="small"
              sx={{ ml: 2 }}
            />
          )}
        </DialogTitle>
        <DialogContent>
          {viewCertificate && (
            <Grid container spacing={3} sx={{ mt: 1 }}>
              <Grid item xs={12} md={6}>
                <Typography variant="subtitle2" color="textSecondary">
                  Verification Code
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.verificationCode}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Student Name
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.studentName}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Student ID
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.studentId}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Course
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.course}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Grade
                </Typography>
                <Chip
                  label={viewCertificate.grade}
                  color={getGradeColor(viewCertificate.grade) as any}
                  size="small"
                  sx={{ mb: 2 }}
                />
              </Grid>
              <Grid item xs={12} md={6}>
                <Typography variant="subtitle2" color="textSecondary">
                  Degree Type
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.degreeType}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  University
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {viewCertificate.university.name}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Issue Date
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {format(new Date(viewCertificate.issueDate), 'MMMM dd, yyyy')}
                </Typography>

                <Typography variant="subtitle2" color="textSecondary">
                  Graduation Date
                </Typography>
                <Typography variant="body1" sx={{ mb: 2 }}>
                  {format(new Date(viewCertificate.graduationDate), 'MMMM dd, yyyy')}
                </Typography>
              </Grid>

              {!viewCertificate.isRevoked && (
                <Grid item xs={12}>
                  <Typography variant="h6" color="error" sx={{ mt: 2, mb: 2 }}>
                    Revoke Certificate
                  </Typography>
                  <TextField
                    fullWidth
                    multiline
                    rows={3}
                    label="Reason for revocation"
                    value={revokeReason}
                    onChange={(e) => setRevokeReason(e.target.value)}
                    placeholder="Enter the reason for revoking this certificate..."
                  />
                </Grid>
              )}
            </Grid>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setViewCertificate(null)}>
            Close
          </Button>
          {viewCertificate && !viewCertificate.isRevoked && (
            <Button
              onClick={handleRevokeCertificate}
              color="error"
              variant="contained"
              disabled={revoking || !revokeReason.trim()}
            >
              {revoking ? 'Revoking...' : 'Revoke Certificate'}
            </Button>
          )}
        </DialogActions>
      </Dialog>
    </Container>
  );
};