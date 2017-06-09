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

subroutine dialum(nno, nddl, ldim, wgt, masco,&
                  masdi)
    implicit none
    real(kind=8) :: masco(*), masdi(*)
    integer :: nno, nddl, ldim
!     ------------------------------------------------------------------
!     PASSAGE D'UNE MATRICE MASSE CONSISTANTE A UNE MATRICE MASSE
!     DIAGONALE SUIVANT LA SPECIAL LUMPING TECHNIQUE
!     ------------------------------------------------------------------
!     IN  NNO   : NOMBRE DE NOEUDS
!     IN  NDDL  : NOMBRE DE DDL PAR NOEUD
!     IN  LDIM  : NOMBRE TOTAL DE DDL DE L ELEMENT
!     IN  WGT   : POIDS ELEMENTAIRE
!     IN  MASCO : MATRICE DE MASSE CONSISTANTE
!     OUT MASDI : MATRICE DE MASSE DIAGONALE
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, k
    real(kind=8) :: wgt, xnul
!-----------------------------------------------------------------------
    parameter    (xnul = 1.d-5)
    integer :: idec, idiag, ndim, ip, itab(300)
    integer :: idirx, idiry, idirz, idirrx, idirry, idirrz
    real(kind=8) :: sommex, sommey, sommez, xinf
    real(kind=8) :: alfax, alfay, alfaz
!
    ip = 0
    sommex = 0.d0
    sommey = 0.d0
    sommez = 0.d0
!-- BOUCLE DE CALCUL DE LA SOMME DES TERMES DIAGONAUX SUIVANT CHAQUE
!   DIRECTION DE TRANSLATION
    ndim = ldim * (ldim+1) / 2
    do 130 i = 1, ndim
        masdi(i)=0.d0
130  end do
    do 145 i = 1, ldim
        idiag = (i*(i+1)/2)
        do 140 k = 1, nno
            idec = (k-1)*nddl+1
            idirx = idec*(idec+1)/2
            idiry = (idec+1)*(idec+2)/2
            idirz = (idec+2)*(idec+3)/2
            if (idiag .eq. idirx) then
                sommex = sommex + masco(idiag)
            else if (idiag.eq.idiry) then
                sommey = sommey + masco(idiag)
            else if (idiag.eq.idirz) then
                sommez = sommez + masco(idiag)
            endif
140      continue
145  end do
    xinf = masco(1)
!-- CALCUL DU COEFFICIENT MULTIPLICATEUR
    alfax = wgt / sommex
    alfay = wgt / sommey
    alfaz = wgt / sommez
!-- BOUCLE DE CALCUL DES TERMES DIAGONNAUX AVEC PROTECTION CONTRE
!-- TERMES DE ROTATION NULS ---> MATRICE SINGULIERE
    do 160 i = 1, ldim
        idiag = (i*(i+1)/2)
        if (masco(idiag) .eq. 0.d0) then
            ip=ip+1
            itab(ip) = idiag
        else
            if (xinf .gt. masco(idiag)) xinf= masco(idiag)
            do 150 k = 1, nno
                idec = (k-1)*nddl+1
                idirx = idec*(idec+1)/2
                idiry = (idec+1)*(idec+2)/2
                idirz = (idec+2)*(idec+3)/2
                idirrx = (idec+3)*(idec+4)/2
                idirry = (idec+4)*(idec+5)/2
                idirrz = (idec+5)*(idec+6)/2
                if (idiag .eq. idirx) then
                    masdi(idiag) = alfax * masco(idiag)
                else if (idiag.eq.idiry) then
                    masdi(idiag) = alfay * masco(idiag)
                else if (idiag.eq.idirz) then
                    masdi(idiag) = alfaz * masco(idiag)
                else if (idiag.eq.idirrx) then
                    masdi(idiag) = alfax * masco(idiag)
                else if (idiag.eq.idirry) then
                    masdi(idiag) = alfay * masco(idiag)
                else if (idiag.eq.idirrz) then
                    masdi(idiag) = alfaz * masco(idiag)
                endif
150          continue
        endif
160  end do
    if (ip .ne. 0) then
        do 170 i = 1, ip
            idec = itab(i)
            masdi(idec) = xnul * alfax * xinf
170      continue
    endif
end subroutine
