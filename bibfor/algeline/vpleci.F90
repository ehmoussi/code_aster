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

subroutine vpleci(eigsol, ktype, indice,&
                  valk, valr, vali)

! ROUTINE UTILITAIRE LISANT LA VALEUR DE LA SD_EIGENSOLVER POUR UN INDICE ET UN TYPE DONNE.
! LE RESULTAT EST RETOURNE DANS VALK, VALI OU VALR.
! POUR LIRE BEAUCOUP DE VALEURS UTILISER PLUTOT VPLECS.
! CF VPINIS, VPLECS, VPLECI, VPECRI.
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none

#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! --- INPUT
!
    integer           , intent(in) :: indice
    character(len=1)  , intent(in) :: ktype
    character(len=19) , intent(in) :: eigsol
!
! --- OUTPUT
!
    integer           , intent(out) :: vali
    real(kind=8)      , intent(out) :: valr
    character(len=24) , intent(out) :: valk
!
! --- INPUT/OUTPUT
! None
!
! --- VARIABLES LOCALES
!
    integer           :: eislvi, eislvk, eislvr
!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!

    call jemarq()

! --   TEST DES PARAMETRES
    ASSERT((ktype.eq.'K').or.(ktype.eq.'R').or.(ktype.eq.'I'))
    ASSERT((indice.ge.1).and.(indice.le.20))

! --  LECTURE PARAMETRES SOLVEURS MODAUX
    select case(ktype)
    case('K')
        ASSERT(indice.le.20)
        call jeveuo(eigsol//'.ESVK', 'L', eislvk)
        valk=''
        valk=trim(zk24(eislvk-1+indice))
    case('I')
        ASSERT(indice.le.15)
        call jeveuo(eigsol//'.ESVI', 'L', eislvi)
        vali=zi(eislvi-1+indice)
    case('R')
        ASSERT(indice.le.15)
        call jeveuo(eigsol//'.ESVR', 'L', eislvr)
        valr=zr(eislvr-1+indice)
    case default
        ASSERT(.false.)
    end select

    call jedema()
!
!     FIN DE VPLECI
!
end subroutine
