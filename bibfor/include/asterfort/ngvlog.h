! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

! aslint: disable=W1504

interface
    subroutine ngvlog(fami,option, typmod, ndim, nno,nnob,neps,&
                      npg, nddl, iw, vff,vffb, idff,idffb,&
                      geomi, compor, mate, lgpg,&
                      crit, angmas, instm, instp, matsym,&
                      ddlm, ddld, sigmg, vim, sigpg,&
                      vipout, fint,matr, codret)
        character(len=*) :: fami              
        character(len=16) :: option
        character(len=8) :: typmod(*)
        integer :: ndim     
        integer :: nno
        integer :: nnob
        integer :: neps        
        integer :: npg
        integer :: nddl
        integer :: iw
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: vffb(nnob, npg)      
        integer :: idff 
        integer :: idffb
        real(kind=8) :: geomi(ndim,nno)
        character(len=16) :: compor(*)
        integer :: mate
        integer :: lgpg
        real(kind=8) :: crit(*)
        real(kind=8) :: angmas(3)
        real(kind=8) :: instm
        real(kind=8) :: instp
        aster_logical :: matsym
        real(kind=8) :: ddlm(nddl)
        real(kind=8) :: ddld(nddl)
        real(kind=8) :: sigmg(neps,npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigpg(neps,npg)
        real(kind=8) :: vipout(lgpg, npg)
        real(kind=8) :: fint(nddl)
        real(kind=8) :: matr(nddl, nddl)
        integer :: codret
    end subroutine ngvlog
end interface
