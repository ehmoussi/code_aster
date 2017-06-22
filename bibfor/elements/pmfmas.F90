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

subroutine pmfmas(nomte, option, rhoflu, icdmat, kanl, mlv)
!
!
! --------------------------------------------------------------------------------------------------
!     CALCUL DE LA MATRICE DE MASSE DES ELEMENTS DE POUTRE MULTIFIBRES
!
!   IN
!       NOMTE   : NOM DU TYPE ELEMENT 'MECA_POU_D_EM' 'MECA_POU_D_TGM'
!
! --------------------------------------------------------------------------------------------------
!
!     REMARQUE : RHOFLU EST UTILISE QUE POUR MASS_FLUI_STRU
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterfort/lonele.h"
#include "asterfort/masstg.h"
#include "asterfort/pmfinfo.h"
#include "asterfort/pmfitg.h"
#include "asterfort/pmfitx.h"
#include "asterfort/pmfm01.h"
#include "asterfort/pmfm21.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: nomte, option
    real(kind=8) :: mlv(*), rhoflu
    integer :: kanl, icdmat
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jacf
    integer :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(10)
    real(kind=8) :: casrho(6), xl, rbid, cars1(6) ,co12, co13
    real(kind=8) :: matp1(78), a, xiy, xiz, casece(6), g
    real(kind=8) :: alfay, alfaz, ey, ez, casect(6)
    character(len=16) :: ch16
! --------------------------------------------------------------------------------------------------
    integer, parameter :: nb_cara = 4
    real(kind=8) :: vale_cara(nb_cara)
    character(len=8) :: noms_cara(nb_cara)
    data noms_cara /'AY1','AZ1','EY1','EZ1'/
! --------------------------------------------------------------------------------------------------
!   Poutres droites multifibres
    if ((nomte .ne. 'MECA_POU_D_EM') .and. (nomte .ne. 'MECA_POU_D_TGM')) then
        ch16 = nomte
        call utmess('F', 'ELEMENTS2_42', sk=ch16)
    endif
!
!   Longueur de l'élément
    xl = lonele()
!
!   Appel intégration sur section
    call pmfitx(icdmat, 2, casrho, rbid)
!
    if (nomte .eq. 'MECA_POU_D_EM') then
!       Calcul de la matrice de masse locale
        call pmfitx(icdmat, 1, casect, rbid)
        co12=casect(3)/casect(1)
        co13=-casect(2)/casect(1)
        call pmfm01(kanl, xl, co12, co13, casrho,mlv)
!
    else if (nomte .eq.'MECA_POU_D_TGM') then
!       Récupération des caractéristiques des fibres
        call pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf=jacf)
!
        call poutre_modloc('CAGNPO', noms_cara, nb_cara, lvaleur=vale_cara)
        alfay = vale_cara(1)
        alfaz = vale_cara(2)
        ey    = vale_cara(3)
        ez    = vale_cara(4)
!
        call pmfitg(tygrfi, nbfibr, nbcarm, zr(jacf), cars1)
        a   = cars1(1)
        xiy = cars1(5)
        xiz = cars1(4)
!
        if (option .eq. 'MASS_FLUI_STRU') then
            casrho(1) = rhoflu * a
            casrho(4) = rhoflu * xiz
            casrho(5) = rhoflu * xiy
        endif
!       Appel intégration sur section
        call pmfitx(icdmat, 1, casece, g)
        matp1(:) = 0.0d0
        call pmfm21(kanl, matp1, casrho, casece, a, xl, xiy, xiz, g, alfay,&
                  alfaz, ey, ez )
!
        call masstg(matp1, mlv)
    endif
!
end subroutine
