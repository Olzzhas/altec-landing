/** @type {import('next').NextConfig} */
const nextConfig = {
    images: {
        remotePatterns: [
          {
            protocol: 'https',
            hostname: 'altayenergoklaster.ru', 
            port: '',
            pathname: '/**', 
          },
        ],
      },
};

export default nextConfig;
