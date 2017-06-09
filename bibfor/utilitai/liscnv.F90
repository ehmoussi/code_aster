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

subroutine liscnv(phenoz, base, lisold, lisnew)
!
    implicit      none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/liscn1.h"
#include "asterfort/liscn2.h"
#include "asterfort/liscrs.h"
#include "asterfort/lisdef.h"
#include "asterfort/lisnnl.h"
#include "asterfort/lissav.h"
!
!
    character(len=*), intent(in) :: phenoz
    character(len=1), intent(in) :: base
    character(len=19), intent(in) :: lisold
    character(len=19), intent(in) :: lisnew
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! CONVERTISSEUR ANCIENNE LISTE_CHARGES -> NOUVELLE LISTE_CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  PHENOM : TYPE DE PHENOMENE (MECANIQUE, THERMIQUE, ACOUSTIQUE)
! IN  BASE   : BASE DE CREATION DE LA SD LISNEW
! IN  LISOLD : SD LISTE DES CHARGES ANCIENNE
! OUT LISNEW : SD LISTE DES CHARGES NOUVELLE
!
! ----------------------------------------------------------------------
!
    character(len=24) :: charge, infcha, fomult
    integer :: jalich, jinfch, jalifc
    integer :: ichar, nbchar
    character(len=8) :: nomcha
    character(len=16) :: typapp, typfct
    integer :: genrec(2), motclc(2)
    character(len=8) :: typech, nomfct, k8bid
    character(len=13) :: prefob
    real(kind=8) :: phase
    integer :: npuis, ibid(2)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES ANCIENNE SD
!
    charge = lisold(1:19)//'.LCHA'
    infcha = lisold(1:19)//'.INFC'
    fomult = lisold(1:19)//'.FCHA'
    call jeveuo(charge, 'L', jalich)
    call jeveuo(infcha, 'L', jinfch)
    call jeveuo(fomult, 'L', jalifc)
    nbchar = zi(jinfch)
    ibid(1) = 0
!
! --- CREATION NOUVELLE SD
!
    call liscrs(lisnew, nbchar, base)
!
! --- LECTURE OCCURRENCES
!
    do 100 ichar = 1, nbchar
!
! ----- NOM DE LA CHARGE
!
        nomcha = zk24(jalich-1+ichar)(1:8)
!
! ----- PREFIXE DE L'OBJET DE LA CHARGE
!
        call lisnnl(phenoz, nomcha, prefob)
!
! ----- GENRES DE LA CHARGE
!
        call lisdef('IDGE', prefob, ibid(1), k8bid, genrec)
!
! ----- TYPE DE LA CHARGE (COMPLEXE, FONCTION, REELLE)
!
        call lisdef('TYPC', prefob, genrec(1), typech, ibid)
!
! ----- MOT-CLEFS DE LA CHARGE
!
        call lisdef('IDMC', prefob, ibid(1), k8bid, motclc)
!
! ----- TYPE D'APPLICATION DE LA CHARGE
!
        call liscn2(lisold, nbchar, ichar, typapp)
!
! ----- RECUPERATION FONCTION MULTIPLICATRICE
!
        call liscn1(lisold, ichar, nomfct, typfct, phase, &
                    npuis)
!
! ----- SAUVEGARDE DES INFORMATIONS
!
        call lissav(lisnew, ichar , nomcha, typech, genrec(1),&
                    motclc, prefob, typapp, nomfct, typfct,&
                    phase , npuis )
!
100 continue
!
    call jedema()
end subroutine
