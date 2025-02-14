# Start with data types

# R has numeric vectors

y = c(1,4,2,3,1) 

# R also has a matrix type which you can construct with the matrix function

# several ways to do it:


A = matrix(c(1,4,2,
             12,1,6,
             21,2,6,
             1,2,5),nrow=3)

A

# Notice how it is rows first

# You can reverse it

A = matrix(c(1,4,2, 12,
             1,6,21,2,
             6,1,2,5),nrow=3,byrow = TRUE)

A

# Now it looks like what I typed

# There is some ambiguity between vectors and column/row vectors, i.e.

y
nrow(y)
ncol(y)

x = matrix(c(1,2,4,1,2),nrow=5)

nrow(x)
ncol(x)

# Transpose function is t

x
t(x)

y
t(y)
t(t(y))

# Notice how t(y) gets promoted to a "maxtrix"

# %*% stands for matrix multiplication

x %*% y # Here y is interpreted as a row vector

y %*% x # Here y is interpreted as a column vector, i.e. when y is a vector
# r uses the ambiguity about whether it is row or column vector to chose whichever format
# makes your operation make sense

# If you try to use regular multiplication it will try to do it elementwise:

x*y

y*x 

# so to calculate an inner product:

sum(x*y)

t(x) %*% y

# Now back to matrix, 

A

# Can use slice indexing
A[1,1:3]

A[c(1,2),c(1,4,3)]

# If you have a big matrix and want to remove a few rows/columns you can use a negative sign in
# indexing

A[-1,]
A

A[,-2]

A

# can modify rows and columns using:

A[,2] = 0
A

A[,1:2] = -1
A

A[1,2:4] = c(1,-1,0)
A

# Can pull out the diagonal:

diag(A)

# Can change it

diag(A) = 2
A

# Can create a diagonal matrix using diag:
diag(c(2,2,1))

# Basic matrix functions

B = matrix(rnorm(16),nrow=4)

B_Inv = solve(B)
B %*% B_Inv

# Can also use solve like a linear system solve
x
y = rnorm(4)

# This will solve for x satisfying Bx = y
solve(B,y)

# You can use this to solve least squares problems if you like

C = matrix(rnorm(4000),ncol=4)
y = rnorm(1000)
solve(t(C) %*% C, t(C) %*% y)

# Several matrix factorizations available

svd(C)

qr(C)

eigen(t(C) %*% (C))

# Can also just solve least squares problems

# I would say the most normal way to solve such problems is using "lm", this is
# good if you are working with tibbles, just note that by default the mode
# will be affine, i.e. we don't have to put the constant in. You can actually
# do it with regular matrices though:

lm(C ~ y)

# If you don't want the constant you can do:

lm(y ~ C - 1)
lm(C ~ 0 + C)

x = lm(y ~ C - 1 )
x_sol = solve(t(C) %*% C, t(C) %*% y)

norm(x$coefficients[1:4]-y)
norm(C %*% x_sol - y)

# Let's repeat the example from meetup-3, with the central park temperatures

library(tidyverse)

setwd("/home/georgehagstrom/work/Teaching/DATA609/website/meetups/Meetup-3/")
central_park = read_csv("central_park_temperature.csv")

central_park
library(lubridate)
central_park = central_park |> mutate(time = ymd(Date)+dhours(hour))
central_park

central_park |> ggplot(aes(x=time,y=temp)) + geom_line()

A = matrix(0,nrow = 2018-7,ncol = 7) # Could habit to preallocate though it probably doesn't matter
x = matrix(central_park$temp[8:nrow(central_park)],ncol = 1)
for (t in 1:nrow(A)){
  A[t,] = matrix(central_park$temp[t:(t+6)],nrow = 1)
}

theta = lm(x ~ A - 1)
theta

x_pred = A %*% theta
df = tibble(x_pred = x_sol, time = central_park$time[8:nrow(central_park)])


