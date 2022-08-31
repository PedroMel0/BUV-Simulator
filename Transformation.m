function vel_global = Transformation(vel_local, eta)

phi = eta(4);
theta = eta(5);
psi = eta(6);

c1=cos(phi);		s1=sin(phi);
c2=cos(theta);		s2=sin(theta);		t2=tan(theta);
c3=cos(psi);		s3=sin(psi);

LG=[
   c3*c2		c3*s2*s1-s3*c1		s3*s1+c3*c1*s2		0			0			0
   s3*c2		c3*c1+s3*s1*s2		s2*s3*c1-c3*s1		0			0			0
   -s2		c2*s1					c2*c1				0			0			0
   0			0						0				1			s1*t2       c1*t2
   0			0						0				0			c1			-s1
   0			0						0				0			s1/c2		c1/c2];

vel_global=LG*vel_local;
