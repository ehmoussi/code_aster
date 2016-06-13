/**
 * @file ContactZone.cxx
 * @brief Implementation de ContactZone
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "Interactions/ContactZone.h"

const std::vector< ContactFormulationEnum > allContactFormulation = { Discretized, Continuous,
                                                                      Xfem, UnilateralConnexion };
const std::vector< std::string > allContactFormulationNames = { "DISCRETE", "CONTINUE",
                                                                "XFEM", "LIAISON_UNIL" };

const std::vector< NormTypeEnum > allNormType = { MasterNorm, SlaveNorm, AverageNorm };
const std::vector< std::string > allNormTypeNames = { "MAIT", "ESCL", "MAIT_ESCL" };

const std::vector< PairingEnum > allPairing = { NewtonPairing, FixPairing };
const std::vector< std::string > allPairingNames = { "PROCHE", "FIXE" };

const std::vector< ContactAlgorithmEnum > allContactAlgorithm = { ConstraintContact, PenalizationContact,
                                                                  GcpContact, StandardContact,
                                                                  CzmContact };
const std::vector< std::string > allContactAlgorithmNames = { "CONTRAINTE", "PENALISATION", "GCP",
                                                              "STANDARD", "CZM" };

const std::vector< FrictionAlgorithmEnum > allFrictionAlgorithm = { FrictionPenalization, StandardFriction };
const std::vector< std::string > allFrictionAlgorithmNames = { "PENALISATION", "STANDARD" };

const std::vector< IntegrationAlgorithmEnum > allIntegrationAlgorithm = { AutomaticIntegration,
                                                                          GaussIntegration,
                                                                          SimpsonIntegration,
                                                                          NewtonCotesIntegration,
                                                                          NodesIntegration };
const std::vector< std::string > allIntegrationAlgorithmNames = { "AUTO", "GAUSS", "SIMPSON",
                                                                  "NCOTES", "NOEUD" };

const std::vector< ContactInitializationEnum > allContactInitialization = { ContactOnInitialization,
                                                                            Interpenetration,
                                                                            NoContactOnInitialization };
const std::vector< std::string > allContactInitializationNames = { "OUI", "INTERPENETRE", "NON" };
