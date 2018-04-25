! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

! ----------------------------------------------------------------------------
! Numerical diagonalization of 3x3 matrcies
! ----------------------------------------------------------------------------
! This library is free software; you can redistribute it and/or
! modify it under the terms of the GNU Lesser General Public
! License as published by the Free Software Foundation; either
! version 2.1 of the License, or (at your option) any later version.
!
! This library is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this library; if not, write to the Free Software
! Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
! ----------------------------------------------------------------------------


! ----------------------------------------------------------------------------
subroutine b3d_jacobi(a,q,w)
! ----------------------------------------------------------------------------
! Calculates the eigenvalues and normalized eigenvectors of a symmetric 3x3
! matrix A using the Jacobi algorithm.
! The upper triangular part of A is destroyed during the calculation,
! the diagonal elements are read but not destroyed, and the lower
! triangular elements are not referenced at all.
! ----------------------------------------------------------------------------
! Parameters:
!   A: The symmetric input matrix
!   Q: Storage buffer for eigenvectors
!   W: Storage buffer for eigenvalues
! ----------------------------------------------------------------------------
!     .. arguments ..
      implicit none
      real(kind=8) :: a(3,3),w(3),q(3,3)
!     .. parameters ..
      integer n
      parameter (n=3)
!     .. local variables ..
      real(kind=8) :: sd, so
      real(kind=8) :: s, c, t
      real(kind=8) :: g, h, z, theta
      real(kind=8) :: thresh
      integer i, x, y, r

      thresh=0.d0
      h=0.d0
      g=0.d0
      theta=0.d0
      i=0
      z=0.0
      x=0
      y=0
      r=0
      s=0.0
      sd=0.0
      so=0.0

!     initialize q to the identitity matrix
!     --- this loop can be omitted if only the eigenvalues are desired ---
!      a=b
      do 10 x = 1, n
        q(x,x) = 1.0d0
        do 11, y = 1, x-1
          q(x, y) = 0.0d0
          q(y, x) = 0.0d0
   11   continue
   10 continue

!     initialize w to diag(a)
      do 20 x = 1, n
        w(x) = a(x, x)
   20 continue

!     calculate sqr(tr(a))  
      sd = 0.0d0
      do 30 x = 1, n
        sd = sd + abs(w(x))
   30 continue
      sd = sd**2
 
!     main iteration loop
      do 40 i = 1, 50
!       test for convergence
        so = 0.0d0
        do 50 x = 1, n
          do 51 y = x+1, n
            so = so + abs(a(x, y))
   51     continue
   50   continue
        if (so .eq. 0.0d0) then
!         print*,'convergence jacobi en ',i,' iterations'
          go to 999
        end if

        if (i .lt. 4) then
          thresh = 0.2d0 * so / n**2
        else
          thresh = 0.0d0
        end if

!       do sweep
        do 60 x = 1, n
          do 61 y = x+1, n
            g = 100.0d0 * ( abs(a(x, y)) )
            if ( i .gt. 4 .and. (abs(w(x)) + g) .eq. abs(w(x))&
                          .and. abs(w(y)) + g .eq. abs(w(y)) ) then
              a(x, y) = 0.0d0
            else if (abs(a(x, y)) .gt. thresh) then
!             calculate jacobi transformation
              h = w(y) - w(x)
              if ( abs(h) + g .eq. abs(h) ) then
                t = a(x, y) / h
              else
                theta = 0.5d0 * h / a(x, y)
                if (theta .lt. 0.0d0) then
                  t = -1.0d0 / (sqrt(1.0d0 + theta**2) - theta)
                else
                  t = 1.0d0 / (sqrt(1.0d0 + theta**2) + theta)
                end if
              end if

              c = 1.0d0 / sqrt( 1.0d0 + t**2 )
              s = t * c
              z = t * a(x, y)
              
!             apply jacobi transformation
              a(x, y) = 0.0d0
              w(x)    = w(x) - z
              w(y)    = w(y) + z
              do 70 r = 1, x-1
                t       = a(r, x)
                a(r, x) = c * t - s * a(r, y)
                a(r, y) = s * t + c * a(r, y)
   70         continue
              do 80, r = x+1, y-1
                t       = a(x, r)
                a(x, r) = c * t - s * a(r, y)
                a(r, y) = s * t + c * a(r, y)
   80         continue
              do 90, r = y+1, n
                t       = a(x, r)
                a(x, r) = c * t - s * a(y, r)
                a(y, r) = s * t + c * a(y, r)
   90         continue

!             update eigenvectors
!             --- this loop can be omitted if only the eigenvalues are desired ---
              do 100, r = 1, n
                t       = q(r, x)
                q(r, x) = c * t - s * q(r, y)
                q(r, y) = s * t + c * q(r, y)
  100         continue
            end if
   61     continue
   60   continue
   40 continue
!      print *, "b3d_jacobi: no convergence."
 999 continue      
      end 
! end of subroutine dsyevj3
