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

subroutine lislec(motfac, phenoz, base, lischa)
!
!
    implicit      none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/liscrs.h"
#include "asterfort/lisdef.h"
#include "asterfort/lislef.h"
#include "asterfort/lisnnl.h"
#include "asterfort/lisnnn.h"
#include "asterfort/lissav.h"
#include "asterfort/listap.h"
    character(len=*) :: phenoz
    character(len=16) :: motfac
    character(len=19) :: lischa
    character(len=1) :: base
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! LECTURE DES CHARGEMENTS
!
! ----------------------------------------------------------------------
!
!
! IN  PHENOM : TYPE DE PHENOMENE (MECANIQUE, THERMIQUE, ACOUSTIQUE)
! IN  MOTFAC : MOT-CLEF FACTEUR DES EXCITATIONS
! IN  BASE   : BASE DE CREATION DE LA SD LISCHA
! OUT LISCHA : SD LISTE DES CHARGES
!
! ----------------------------------------------------------------------
!
    integer :: iexci, nbexci, ibid, ibid2(2)
    character(len=8) :: charge, k8bid
    character(len=16) :: typapp, typfct
    integer :: genrec(2), motclc(2)
    character(len=8) :: typech, nomfct
    character(len=13) :: prefob
    real(kind=8) :: phase
    integer :: npuis
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- NOMBRE D'EXCITATIONS
!
    call getfac(motfac, nbexci)
!
! --- CREATION SD CHARGEMENT
!
    if (nbexci.ne.0) call liscrs(lischa, nbexci, base)
!
! --- LECTURE OCCURRENCES EXCIT
!
    do 100 iexci = 1, nbexci
!
! ----- LECTURE NOM DE LA CHARGE (PROVENANT DE AFFE_CHAR_*)
!
        call lisnnn(motfac, iexci, charge)
!
! ----- PREFIXE DE L'OBJET DE LA CHARGE
!
        call lisnnl(phenoz, charge, prefob)
!
! ----- GENRES DE LA CHARGE
!
        call lisdef('IDGE', prefob, ibid, k8bid, genrec)
!
! ----- MOT-CLEFS DE LA CHARGE
!
        call lisdef('IDMC', prefob, ibid, k8bid, motclc)
!
! ----- TYPE DE LA CHARGE (COMPLEXE, FONCTION, REELLE)
!
        call lisdef('TYPC', prefob, genrec(1), typech, ibid2)
!
! ----- TYPE D'APPLICATION DE LA CHARGE
!
        call listap(motfac, iexci, typapp)
!
! ----- RECUPERATION FONCTION MULTIPLICATRICE
!
        call lislef(motfac, iexci, nomfct, typfct, phase,&
                    npuis)
!
! ----- SAUVEGARDE DES INFORMATIONS
!
        call lissav(lischa, iexci, charge, typech, genrec(1),&
                    motclc, prefob, typapp, nomfct, typfct,&
                    phase, npuis)
!
100 continue
!
    call jedema()
end subroutine
