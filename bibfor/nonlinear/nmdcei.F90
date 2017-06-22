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

subroutine nmdcei(sddisc, nume_inst, newins, nb_inst_ini, nb_inst_ins,&
                  typext, dt0)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8maem.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utdidt.h"
    integer :: nb_inst_ins, nume_inst, nb_inst_ini
    character(len=19) :: sddisc
    real(kind=8) :: newins(nb_inst_ins)
    real(kind=8) :: dt0
    character(len=4) :: typext
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - DECOUPE)
!
! EXTENSION DE LA LISTE D'INSTANTS
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! IN  NEWINS : VECTEUR DES NOUVEAUX INSTANTS A AJOUTER (LONGUEUR NBINS)
! IN  NUMINS : NUMERO D'INSTANT
! IN  NBINS  : NOMBRE DE PAS DE TEMPS A INSERER
! IN  NBINI  : ANCIEN NOMBRE D'INSTANTS
! IN  TYPEXT : TYPE D'EXTENSION
!               'ADAP' - ADAPTATION DU PAS DE TEMPS
!               'DECO' - DECOUPAGE DU PAS DE TEMPS
! OUT DT0    : NOUVEAU DELTAT
!
!
!
!
    integer :: i_inst, nb_inst_new
    character(len=24) :: tpsdit
    integer :: jtemps
    real(kind=8) :: time, deltat, dtmin
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD LISTE D'INSTANTS
!
    tpsdit = sddisc(1:19)//'.DITR'
!
! --- NOUVEAU NOMBRE D'INSTANTS
!
    nb_inst_new = nb_inst_ini + nb_inst_ins
!
! --- ALLONGEMENT DE LA LISTE D'INSTANTS
!
    call juveca(tpsdit, nb_inst_new)
    call jeveuo(tpsdit, 'E', jtemps)
!
! --- RECOPIE DE LA PARTIE HAUTE DE LA LISTE
!
    do i_inst = nb_inst_ini, nume_inst+1, -1
        time = zr(jtemps+i_inst-1)
        zr(jtemps+i_inst+nb_inst_ins-1) = time
    end do
!
! --- INSERTION DES INSTANTS SUPPLEMENTAIRES
!
    do i_inst = 1, nb_inst_ins
        time = newins(i_inst)
        if (typext .eq. 'DECO') then
            zr(jtemps+i_inst+nume_inst-1) = time
        else if (typext.eq.'ADAP') then
            zr(jtemps+i_inst+nume_inst) = time
        else
            ASSERT(.false.)
        endif
    end do
!
! --- VALEUR DU NOUVEAU DELTAT
!
    dt0 = zr(jtemps-1+nume_inst+1)-zr(jtemps-1+nume_inst)
!
! --- NOUVEL INTERVALLE DE TEMPS MINIMAL : DTMIN
!
    dtmin = r8maem()
    do i_inst = 1, nb_inst_new-1
        deltat = zr(jtemps-1+i_inst+1) - zr(jtemps-1+i_inst)
        dtmin = min(deltat,dtmin)
    end do
!
! --- ENREGISTREMENT INFOS
!
    call utdidt('E', sddisc, 'LIST', 'NBINST',&
                vali_ = nb_inst_new)
    call utdidt('E', sddisc, 'LIST', 'DTMIN',&
                valr_ = dtmin)
!
    call jedema()
!
end subroutine
