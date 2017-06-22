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

subroutine nmdcdc(sddisc, numins, nomlis, nbrpas)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmdcei.h"
#include "asterfort/nmdcen.h"
#include "asterfort/utdidt.h"
    character(len=19) :: sddisc
    character(len=24) :: nomlis
    integer :: nbrpas, numins
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! MISE A JOUR DES SD APRES DECOUPE
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! IN  NUMINS : NUMERO D'INSTANTS
! IN  NOMLIS : NOM DE LA LISTE DES INSTANTS A AJOUTER
! IN  NBRPAS : NOMBRE D'INSTANTS A AJOUTER
!
!
!
!
    integer :: jinst
    integer :: nb_inst_ins, nb_inst_ini
    real(kind=8) :: dt0
    character(len=16) :: metlis
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES OBJET INST
!
    call jeveuo(nomlis, 'L', jinst)
!
! --- GESTION DE LA LISTE D'INSTANT
!
    call utdidt('L', sddisc, 'LIST', 'METHODE',&
                valk_ = metlis)
!
! --- LONGUEUR INITIALE DE LA LISTE D'INSTANTS
!
    call utdidt('L', sddisc, 'LIST', 'NBINST',&
                vali_ = nb_inst_ini)
!
! --- NOMBRE D'INSTANTS A AJOUTER
!
    if (metlis .eq. 'AUTO') then
        nb_inst_ins = 1
    else if (metlis.eq.'MANUEL') then
        nb_inst_ins = nbrpas - 1
    else
        ASSERT(.false.)
    endif
!
! --- EXTENSION DE LA LISTE D'INSTANTS
!
    call nmdcei(sddisc, numins, zr(jinst), nb_inst_ini, nb_inst_ins,&
                'DECO', dt0)
!
! --- EXTENSION DE LA LISTE DES NIVEAUX DE DECOUPAGE
!
    call nmdcen(sddisc, numins, nb_inst_ini, nb_inst_ins)
!
! --- ENREGISTREMENT INFOS
!
    call utdidt('E', sddisc, 'LIST', 'DT-',&
                valr_ = dt0)
!
    call jedema()
end subroutine
