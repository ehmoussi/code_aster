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

subroutine lcumfb(sigi, nstrs, vari, nvari, cmat,&
                  nmat, tdt, hini, hfin, afd,&
                  bfd, cfd)
    implicit none
    integer :: nstrs, nvari, nmat
    real(kind=8) :: sigi(6), vari(nvari), cmat(nmat)
    real(kind=8) :: tdt, hini, hfin, afd(6), bfd(6, 6), cfd(6, 6)
!_______________________________________________________________________
!
! SOUS PROGRAMME QUI CALCUL LES MATRICE DE DEFORMATION DE FLUAGE
!   DE DESSICCATION D APRES LE MODELE DE BAZANT OU UMLV
!
!     - MODELE DE BAZANT : IDES = 1 => EQUATION (3.3-2)
!     - MODELE DE UMLV   : IDES = 2 => EQUATION (3.3-4)
!
!   DFDES(N+1) = AFD + BFD * SIGMA(N) + CFD * SIGMA(N+1)
!
!    => EQUATION (3.3-1)
!_______________________________________________________________________
!
    integer :: i, j, ides
    real(kind=8) :: a, b, c, efde(6)
    real(kind=8) :: vdes, dh, defdef
!
! RECUPERATION DES VALEURS DES PARAMETRES MATERIAU
!
!  25 AOUT 2004 - YLP
! LE MODELE DE BAZANT NE COMPREND QU'UN PARAMETRE
!      RDES = CMAT(10)
    vdes = cmat(11)
    ides = nint(cmat(14))
!
! TEST SI TDT = 0
!
    if (tdt .eq. 0.d0) then
!        CALL ZERO(AFD,NSTRS,1)
!        CALL ZERO(BFD,NSTRS,NSTRS)
!        CALL ZERO(CFD,NSTRS,NSTRS)
        do 1 i = 1, nstrs
            afd(i) = 0.0d0
            do 2 j = 1, nstrs
                bfd(i,j) = 0.0d0
                cfd(i,j) = 0.0d0
 2          continue
 1      continue
        goto 30
    endif
!
! RECUPERATION DES VARIABLES INTERNES INITIALES
!
    efde(1) = vari(9)
    efde(2) = vari(10)
    efde(3) = vari(11)
    efde(4) = vari(18)
    efde(5) = vari(19)
    efde(6) = vari(20)
!
! INITIALISATION DES VARIABLES
!
    dh = abs(hfin-hini)
!
! AIGUILLAGE SUIVANT LA VALEUR DE IDES
!
    if (ides .eq. 1) then
!
! MODELE DE BAZANT : STRESS-INDUCED SHRINKAGE => EQUATION (3.3-3)
!
        a = 0.d0
        b = dh / (2.d0*vdes)
        c = b
!
! MODELE UMLV => EQUATION (3.3-5)
!
!      ELSEIF (IDES.EQ.2) THEN
!        TEQ = VDES / RDES
!        TQEXP = DEXP(-TDT/TEQ)
!        A = (TQEXP - 1.D0)
!        B = 2.*DH/RDES*((1.D0 - TQEXP) * (1.D0 + TEQ / TDT) - 1.D0)
!        C = 0.D0
!
    endif
!
! CONSTRUCTION DE LA MATRICE DE FLUAGE DE DESSICCATION
!
    do 10 i = 1, nstrs
        afd(i) = a * efde(i)
        bfd(i,i) = b
        cfd(i,i) = c
10  end do
!
! VERIFICATION DE LA CROISSANCE DE LA DEFORMATION
!
    if (ides .eq. 2) then
        do 20 i = 1, nstrs
            defdef = afd(i) + bfd(i,i) * sigi(i)
            if (defdef .gt. 0.d0) then
                afd(i) = 0.d0
                bfd(i,i) = 0.d0
                cfd(i,i) = 0.d0
            endif
20      continue
    endif
!
30  continue
!
end subroutine
