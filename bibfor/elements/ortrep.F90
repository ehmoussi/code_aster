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

subroutine ortrep(ndim, coor, repere)
!.======================================================================
    implicit none
!
!      ORTREP   -- RECUPERATION DES DONNEES UTILISATEUR
!                  DEFINISSANT LE REPERE D'ORTHOTROPIE
!                  RELATIF A L'ELEMENT COURANT
!                  I.E. OU BIEN ON DONNE LES 3 ANGLES
!                       NAUTIQUES DEFINISSANT LE REPERE
!                       D'ORTHOTROPIE
!                       OU BIEN DANS LE CAS OU L'ELEMENT APPARTIENT
!                       A UNE STRUCTURE A SYMETRIE CYLINDRIQUE
!                       ON DONNE L'AXE DE SYMETRIE (LA DIRECTION
!                       ETANT DEFINIE PAR LES 2 PREMIERS ANGLES
!                       NAUTIQUES ET L'AXE DEFINI PAR CETTE DIRECTION
!                       ET UN POINT DONNE PAR L'UTILISATEUR)
!
!   ARGUMENT        E/S  TYPE         ROLE
!    MATER          IN      I        MATERIAU
!    NDIM           IN      I        DIMENSION DE LA MODELISATION
!    COOR           IN      R        COORDONNEE DU POINT
!                                    (CAS CYLINDRIQUE)
!    REPERE(7)      OUT     R        VALEURS DEFINISSANT LE REPERE
!                                    D'ORTHOTROPIE
!
!.========================= DEBUT DES DECLARATIONS ====================
! -----  ARGUMENTS
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/angvxy.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/utrcyl.h"
    real(kind=8) :: repere(7), coor(3)
    integer :: ndim
!
! -----  VARIABLES LOCALES
    integer :: nbres, i, iret, icamas, imate
    parameter         ( nbres=9 )
    integer :: icodre(nbres)
    character(len=16) :: phenom
    real(kind=8) :: p(3, 3), xg(3), yg(3), orig(3), dire(3)
    real(kind=8) :: alpha, beta, angmas(3)
!.========================= DEBUT DU CODE EXECUTABLE ==================
!
!
! ---- INITIALISATIONS :
!      ----------------
!
    do 10 i = 1, 7
        repere(i) = 0.0d0
10  end do
!
    call tecach('NNO', 'PCAMASS', 'L', iret, iad=icamas)
!
    if (iret .ne. 0) then
!     --------------------
        repere(1) = 1.d0
!
    else
!     ----
!
        call jevech('PMATERC', 'L', imate)
! ---- TRAITEMENT DU CAS 3D :
!      ====================
        if (ndim .eq. 3) then
!
! ----   RECUPERATION DE LA NATURE DU MATERIAU DANS PHENOM
!        -------------------------------------------------
            call rccoma(zi(imate), 'ELAS', 1, phenom, icodre(1))
!
            if (phenom .eq. 'ELAS_ORTH' .or. phenom .eq. 'ELAS_ISTR') then
!
                call jevech('PCAMASS', 'L', icamas)
!
                repere(1) = zr(icamas)
!
                if (zr(icamas) .gt. 0.0d0) then
!
! ----      ANGLES NAUTIQUES
!           ----------------
                    repere(2) = zr(icamas+1)*r8dgrd()
                    repere(3) = zr(icamas+2)*r8dgrd()
                    repere(4) = zr(icamas+3)*r8dgrd()
                else
!
!-----      LES INFORMATIONS FOURNIES SONT POUR UN REPERE
!-----      CYLINDRIQUES. ON TRANSFORME DIRECTEMENT
!-----      EN REPERE LOCAL CARTESIEN
                    alpha=zr(icamas+1)*r8dgrd()
                    beta =zr(icamas+2)*r8dgrd()
                    dire(1) = cos(alpha)*cos(beta)
                    dire(2) = sin(alpha)*cos(beta)
                    dire(3) = -sin(beta)
                    orig(1)=zr(icamas+4)
                    orig(2)=zr(icamas+5)
                    orig(3)=zr(icamas+6)
                    call utrcyl(coor, dire, orig, p)
                    do 1 i = 1, 3
                        xg(i)=p(1,i)
                        yg(i)=p(2,i)
 1                  continue
                    call angvxy(xg, yg, angmas)
                    repere(1)=1.d0
                    repere(2)=angmas(1)
                    repere(3)=angmas(2)
                    repere(4)=angmas(3)
                endif
            endif
!
! ---- TRAITEMENT DU CAS 2D :
!      ====================
        else if (ndim.eq.2) then
!
! ----   RECUPERATION DE LA NATURE DU MATERIAU DANS PHENOM
!        -------------------------------------------------
            call rccoma(zi(imate), 'ELAS', 1, phenom, icodre(1))
!
            if (phenom .eq. 'ELAS_ORTH' .or. phenom .eq. 'ELAS_ISTR') then
!
                call jevech('PCAMASS', 'L', icamas)
!
                repere(1) = zr(icamas)
!
                if (zr(icamas) .gt. 0.0d0) then
!
! ----      ANGLE NAUTIQUE
!           --------------
                    repere(2) = zr(icamas+1)*r8dgrd()
!
                else
                    repere(1)=1.d0
                    call utmess('F', 'ELEMENTS2_38')
                endif
            endif
        endif
    endif
!     -----
!
!.============================ FIN DE LA ROUTINE ======================
end subroutine
