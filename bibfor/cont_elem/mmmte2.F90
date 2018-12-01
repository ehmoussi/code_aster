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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmmte2(ndim  , nnl   , nne   , nnm   , nbcpf , ndexcl,&
                  matrff, matrfe, matrfm, matref, matrmf)
!
implicit none
!
integer, intent(in) :: ndim, nne, nnl, nnm, nbcpf, ndexcl(10)
real(kind=8), intent(inout) :: matrff(18, 18), matref(27, 18), matrfe(18, 27)
real(kind=8), intent(inout) :: matrmf(27, 18), matrfm(18, 27)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Modify matrices for excluded nodes
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nbcpf            : number of components by node for Lagrange multiplicators for friction
! In  ndexcl           : list of nodes for EXCL_FROT_* keyword
! IO  matrff           : matrix for DOF [friction x friction]
! IO  matrfe           : matrix for DOF [friction x slave]
! IO  matrfm           : matrix for DOF [friction x master]
! IO  matref           : matrix for DOF [slave x friction]
! IO  matrmf           : matrix for DOF [master x friction]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoe, inom, inof, idim, jj, ii, l, icmp, i
!
! --------------------------------------------------------------------------------------------------
!
    do i = 1, nnl
        if (ndexcl(i) .eq. 1) then
            do l = 1, nbcpf
                if ((l.eq.2) .and. (ndexcl(10).eq.0)) then
                    cycle
                endif
                ii = nbcpf*(i-1)+l
                matrff(ii,ii) = 1.d0
            end do
        endif
    end do
!
    do inof = 1, nnl
        if (ndexcl(inof) .eq. 1) then
            do inoe = 1, nne
                do icmp = 1, nbcpf
                    if ((icmp.eq.2) .and. (ndexcl(10).eq.0)) then
                        cycle
                    endif
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inoe-1)+idim
                        matrfe(ii,jj) = 0.d0
                    end do
                end do
            end do
        endif
    end do
!
    do inof = 1, nnl
        if (ndexcl(inof) .eq. 1) then
            do inom = 1, nnm
                do icmp = 1, nbcpf
                    if ((icmp.eq.2) .and. (ndexcl(10).eq.0)) then
                        cycle
                    endif
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inom-1)+idim
                        matrfm(ii,jj) = 0.d0
                    end do
                end do
            end do
        endif
    end do
!
    do inof = 1, nnl
        if (ndexcl(inof) .eq. 1) then
            do inoe = 1, nne
                do icmp = 1, nbcpf
                    if ((icmp.eq.2) .and. (ndexcl(10).eq.0)) then
                        cycle
                    endif
                    do idim = 1, ndim
                        jj = nbcpf*(inof-1)+icmp
                        ii = ndim*(inoe-1)+idim
                        matref(ii,jj) = 0.d0
                    end do
                end do
            end do
        endif
    end do
!
    do inof = 1, nnl
        if (ndexcl(inof) .eq. 1) then
            do inom = 1, nnm
                do icmp = 1, nbcpf
                    if ((icmp.eq.2) .and. (ndexcl(10).eq.0)) then
                        cycle
                    endif
                    do idim = 1, ndim
                        jj = nbcpf*(inof-1)+icmp
                        ii = ndim*(inom-1)+idim
                        matrmf(ii,jj) = 0.d0
                    end do
                end do
            end do
        endif
    end do
!
end subroutine
