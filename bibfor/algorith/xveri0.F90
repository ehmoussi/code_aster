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

subroutine xveri0(ndime, elrefp, ksi, iret) 
    implicit none
    character(len=8) :: elrefp
    integer :: iret, ndime
    real(kind=8) :: ksi(*)
!
!     BUT: VERIFIER SI LES COORDONNEES DE REFERENCE CALCULEES 
!             SONT DANS LE DOMAINE DE L ELEMENT PARENT DE REFERENCE
!
!     ENTREE
!        NDIME : DIMENSION TOPOLOGIQUE DE L ELEMENT DE REFERENCE
!        ELREFP: TYPE ELEMENT PARENT
!        KSI   : COORDONNEES A VERIFIER
!     SORTIE
!        IRET  : CODE RETOUR : SI IRET = 0 ALORS OK
!                                      > 0 ALORS NOOK
!----------------------------------------------------------------------
    integer :: j
    real(kind=8) :: plan, tole, zero, one
    parameter   (tole=1.d-12)
!INTRODUCTION D UNE TOLERENCE GEOMETRIQUE POUR CAPTER LES POINTS SUR LE BORD DE L ELEMENT
!PAS BESOIN DE MISE A L ECHELLE DANS L ESPACE PARAMETRIQUE DE REFERENCE
!----------------------------------------------------------------------
     iret=0
     zero=-tole
     one=1.d0+tole
     if    ((elrefp .eq. 'TE4') .or. (elrefp .eq. 'T10') .or.&
            (elrefp .eq. 'TR3') .or. (elrefp .eq. 'TR6') .or.&
            (elrefp .eq. 'TR7')) then
           plan=1.d0
           do  j=1,ndime
              if(ksi(j) .lt. zero) iret=iret+1
              plan=plan-ksi(j)
           enddo        
           if(plan .lt. zero) iret=iret+1  
     elseif((elrefp .eq. 'PE6') .or. (elrefp .eq. 'P15') .or.&
            (elrefp .eq. 'P18')) then
           if (abs(ksi(1)) .gt. one) iret=iret+1
           if ((ksi(2) .gt. one) .or. (ksi(3) .gt. one)) iret=iret+1
           plan=1.d0-ksi(2)-ksi(3)
           if(plan .lt. zero) iret=iret+1 
     elseif((elrefp .eq. 'PY5') .or. (elrefp .eq. 'P13')) then
           if (ksi(3) .lt. zero) iret=iret+1
           plan=1.d0-ksi(1)-ksi(2)-ksi(3)
           if(plan .lt. zero) iret=iret+1 
           plan=1.d0-ksi(1)+ksi(2)-ksi(3)
           if(plan .lt. zero) iret=iret+1 
           plan=1.d0+ksi(1)-ksi(2)-ksi(3)
           if(plan .lt. zero) iret=iret+1 
           plan=1.d0+ksi(1)+ksi(2)-ksi(3)
           if(plan .lt. zero) iret=iret+1 
     else
        do  j=1,ndime
           if(abs(ksi(j)) .gt. one)  iret=iret+1
        enddo
     endif
end subroutine
